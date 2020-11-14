module CustomLandingPageHelper

  def cta_button_text_locals(form, button_type_button)
    {
      header: form.label(:cta_button_text),
      input_classes: "",
      input_name: "section[cta_button_text]",
      placeholder: t("admin.landing_page_versions.sections.cta_button.text_placeholder"),
      required: button_type_button ? true : nil,
      info_text: t(".cta_button_info"),
      show_info_text: button_type_button,
      info_text_id: "cta-button-info",
      value: form.object.cta_button_text
    }
  end

  def cta_button_url_locals(form, button_type_button)
    {
      header: form.label(:cta_button_url),
      input_classes: "",
      input_name: "section[cta_button_url]",
      placeholder: t("admin.landing_page_versions.sections.cta_button.url_placeholder"),
      required: button_type_button ? true : nil,
      value: form.object.cta_button_url
    }
  end

  def common_locals(input_name, form)
    {
      header: form.label(input_name),
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: nil
    }
  end

  def cta_locals(input_name, form, placeholder = "", required = nil, url = nil)
    {
      header: form.label(input_name),
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: required,
      placeholder: placeholder,
      url: url
    }
  end

  def locations_locals(input_name, index, form, placeholder = "", url = nil)
    {
      input_classes: "",
      input_name: "section[locations_attributes][#{index}][#{input_name}]",
      value: form.object.try(input_name),
      placeholder: placeholder,
      url: url,
      required: nil
    }
  end

  def video_locals(input_name, form, info_text = "", placeholder = "", required = nil)
    {
      header: form.label(input_name),
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: required,
      placeholder: placeholder,
      url: nil,
      show_info_text: true,
      info_text: info_text
    }
  end

  def listings_locals(input_name, form)
    {
      header: form.label(input_name),
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: nil
    }
  end

  def copyright_locals(input_name, form)
    {
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: nil
    }
  end

  def footer_links_locals(input_name, index, form, placeholder = "", url = nil, required = nil, hide_locale = false)
    {
      input_classes: "",
      input_name: "section[links_attributes][#{index}][#{input_name}]",
      value: form.object.try(input_name),
      placeholder: placeholder,
      url: url,
      required: required,
      maxlength: 255,
      hide_locale: hide_locale
    }
  end

  def multi_columns_title_locals(input_name, form, label = "")
    {
      header: form.label(input_name, label),
      input_classes: "",
      input_name: "section[#{input_name}]",
      value: form.object.try(input_name),
      required: nil
    }
  end

  def multi_columns_common_locals(input_name, value, label = "")
    {
      header: label_tag(input_name, label),
      input_classes: "",
      input_name: input_name,
      value: value,
      required: nil
    }
  end

  def multi_columns_button_locals(input_name, value, placeholder = "", url = nil, hide_locale = false)
    {
      input_classes: "",
      input_name: input_name,
      value: value,
      required: nil,
      placeholder: placeholder,
      url: url,
      hide_locale: hide_locale
    }
  end

end
