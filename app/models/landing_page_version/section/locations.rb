module LandingPageVersion::Section
  class Locations < Base
    class Location
      include ActiveModel::Model

      ATTRIBUTES = [
        :id,
        :asset_id,
        :sort_priority,
        :_destroy,
        :image,
        :title,
        :url
      ]

      PERMITTED_PARAMS = [
        :id,
        :asset_id,
        :sort_priority,
        :_destroy,
        :image
      ]

      LOCALIZED_PARAMS = [
        :title,
        :url
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def new_record?
        id.nil?
      end

      def self.from_serialized_hash(location, index)
        self.new(
          id: index,
          title: location['title'],
          asset_id: location['background_image']['id'],
          url: location['location']['value'],
          sort_priority: index)
      end

      def serializable_hash(options = nil)
        {
          title: title,
          location: { value: url },
          background_image: { type: "assets", id: asset_id}
        }
      end
    end

    ATTRIBUTES = [
      :id,
      :kind,
      :title,
      :paragraph,
      :button_color,
      :button_color_hover,
      :button_title,
      :button_path,
      :locations,
      :background_image_variation,
      :background_image,
      :background_color,
      :location_color_hover
    ].freeze

    DEFAULTS = {
      title: nil,
      background_image: nil,
      background_image_variation: nil,
      paragraph: nil,
      button_color: {type: "marketplace_data", id: "primary_color"},
      button_color_hover: {type: "marketplace_data", id: "primary_color_darken"},
      button_title: nil,
      button_path: nil,
      location_color_hover: {type: "marketplace_data", id: "primary_color"},
      locations: [
        {
          'location' => { },
          'background_image' => { }
        },
        {
          'location' => { },
          'background_image' => { }
        },
        {
          'location' => { },
          'background_image' => { }
        },
      ]
    }

    PERMITTED_PARAMS = [
      :id,
      :kind,
      :previous_id,
      :cta_enabled,
      :background_style,
      :background_color_string,
      :background_image_variation,
      :location_color_hover,
      :locations_attributes => LandingPageVersion::Section::Locations::Location::ATTRIBUTES
    ]

    LOCALIZED_PARAMS = [
      :title,
      :paragraph,
      :button_title,
      :button_path_string,
    ].freeze

    ENCLOSED_LOCALIZED_PARAMS = [
      :locations_attributes
    ].freeze

    attr_accessor(*(ATTRIBUTES + HELPER_ATTRIBUTES))

    attr_writer :background_style

    before_save :check_extra_attributes

    def initialize(attributes={})
      super(attributes)
      @kind = LandingPageVersion::Section::LOCATIONS
      DEFAULTS.each do |key, value|
        unless self.send(key)
          self.send("#{key}=", value)
        end
      end
    end

    def attributes
      Hash[ATTRIBUTES.map {|x| [x.to_s, nil]}]
    end

    def i18n_key
      'locations'
    end

    # serialize links and social as associations, not regular attributes
    def serializable_hash(options = nil)
      super({except: [:locations], include: [:locations]})
    end

    # called on initialization from model
    def locations=(list)
      @locations = list.map.with_index do |location, index|
        if location.is_a?(Hash)
          LandingPageVersion::Section::Locations::Location.from_serialized_hash(location, index)
        else
          location
        end
      end
    end

    # called from controller
    def locations_attributes=(params)
      @locations = priority_sort(params).reject{|r| r['_destroy'] == '1'}.map do |attrs|
        location = LandingPageVersion::Section::Locations::Location.new(attrs)
        new_asset = attrs['image']
        if new_asset.is_a?(ActiveStorage::Attachment)
          location.asset_id = "location_#{id}_#{new_asset.id}"
          add_or_replace_asset(new_asset, location.asset_id, LOCATION_IMAGE_RESIZE_OPTIONS)
        end
        location
      end
    end

    def new_location
      LandingPageVersion::Section::Locations::Location.new
    end

    def priority_sort(params)
      params.values.sort_by{|p| p['sort_priority'].to_i}
    end

    def asset_added(new_asset)
      self.background_image = {'type' => 'assets', 'id' => self.id+"_background_image"}
      add_or_replace_asset(new_asset, background_image['id'], BACKGROUND_RESIZE_OPTIONS)
    end

    def removable?
      true
    end

    class << self
      def new_from_content(content_section)
        new(content_section)
      end

      def permitted_params(locales)
        localized_params = LOCALIZED_PARAMS.map {|param|
          { param => locales }
        }
        enclosed_localized_params = {}
        LandingPageVersion::Section::Locations::Location::LOCALIZED_PARAMS.each {|param|
          enclosed_localized_params[param] = { param => locales }
        }

        permitted_params = PERMITTED_PARAMS.map {|p|
          if p.is_a?(Hash) && !(l_params = p.keys & ENCLOSED_LOCALIZED_PARAMS).empty?
            r = {}
            l_params.each {|lp_key|
              s = p[lp_key].map {|l|
                if enclosed_localized_params.key?(l)
                  enclosed_localized_params[l]
                else
                  l
                end
              }
              r = r.merge({lp_key => s})
            }
            r
          else
            p
          end
        }
        permitted_params + localized_params
      end
    end
  end
end
