module Bulma
  # # Bulma Form Helper
  #
  # Module Bulma FormHelper overrides the Rails form helpers to generate elements that are decorated with Bulma CSS
  # classes. Here is an example of the generated html from the `text_field` helper (with a User model):
  #
  #   f.text_field :name, class: "input"
  #
  #   <div class="field">
  #     <label for="name" class="label">Name</label>
  #     <div class="control">
  #       <input id="user_name" class="input" type="text">
  #     </div>
  #   </div>
  #
  # In addition to the standard options, the following options are supported for inputs:
  # - suppress_label: Do not render the label tag
  # - icon_left: Add an icon to the left of the input field
  # - icon_right: Add an icon to the right of the input field
  #
  # The two icon options should be a string that represents the icon class. For example, "fas fa-user" would render a user
  # icon from Font Awesome.
  module FormHelper
    def text_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def password_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def telephone_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def date_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def time_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def datetime_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def month_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def week_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def url_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def email_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def number_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def range_field(object_name, method, options = {})
      options = options.dup
      wrap_input_field(object_name, method, options) { super object_name, method, options }
    end

    def submit_tag(value = "Save", options = {})
      return super if options.delete(:delivered)

      append_classes_to_options(options, "button")
      wrap_with_control { super }
    end

    def checkbox(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
      tag.div(class: "field") do
        tag.div(class: "control") do
          label(object_name, method, class: "checkbox") do
            concat super
            concat " #{t(method, scope: [ :helpers, :label, object_name ])}"
          end
        end
      end
    end

    def checkbox_display(object_name, method, checked)
      icon = checked ? "far fa-lg fa-square-check" : "fa-regular fa-square"

      tag.div(class: "field") do
        tag.div(class: "control") do
          concat icon_span(icon, "is-medium")
          concat tag.span t(method, scope: [ :helpers, :label, object_name ])
        end
      end
    end

    def select(object, method, choices = nil, options = {}, html_options = {}, &block)
      wrap_with_field_and_label(object, method, options, suppress_label: options.delete(:suppress_label), column: options.delete(:column)) do
        wrap_with_control do
          tag.div(class: class_names(:select, is_danger: attribute_has_errors?(options, method))) { super }
        end
      end
    end

    def collection_select(object, method, collection, value_method, text_method, options = {}, html_options = {})
      wrap_with_field_and_label(object, method, options, suppress_label: options.delete(:suppress_label), column: options.delete(:column)) do
        wrap_with_control do
          tag.div(class: class_names(:select, is_danger: attribute_has_errors?(options, method))) { super }
        end
      end
    end

    def file_field(object_name, method, options = {})
      append_classes_to_options(options, "file-input")
      append_data_attributes_to_options(options, bulma__file_input_display_target: "fileInput", action: "bulma--file-input-display#show")
      accepted_file_types = options.fetch(:accept, "").split(",").map(&:strip)

      # [File Upload](https://bulma.io/documentation/form/file/)
      tag.div(class: "file is-boxed", data: { controller: "bulma--file-input-display", bulma__file_input_display_accepted_file_types_value: accepted_file_types }) do
        tag.label(class: "file-label") do
          concat super
          concat(tag.span(class: "file-cta") do
            concat tag.span(class: "file-icon") { tag.i(class: "fas fa-upload") }
            concat tag.span(class: "file-label") { t(method, scope: [ "helpers", "label", object_name ]) }
          end)
          concat tag.div(class: "content", data: { bulma__file_input_display_target: "fileList" }) { "No file(s) selected" }
        end
      end
    end

    def textarea(object_name, method, options = {})
      append_classes_to_options(options, "textarea")

      wrap_with_field_and_label(object_name, method, options, suppress_label: options.delete(:suppress_label), column: options.delete(:column)) do
        wrap_with_control { super }
      end
    end

    def text_area(object_name, method, options = {})
      textarea(object_name, method, options)
    end

    private

    # [Form Control](https://bulma.io/documentation/form/general/#form-control)
    def wrap_with_control
      tag.div(class: "control") { yield }
    end

    # [Form Input](https://bulma.io/documentation/form/general/#complete-form-example)
    def wrap_input_field(object_name, method, options)
      options.extend(InputOptionsParser)
      append_classes_to_options(options, "input")
      append_classes_to_options(options, "is-danger") if attribute_has_errors?(options, method)

      wrap_with_field_and_label(object_name, method, options, suppress_label: options.suppress_label?, column: options.column?) do
        tag.div(class: class_names(:control, options.icon_control_classes)) do
          concat yield
          concat icon_span(options.icon_left, "is-small is-left") if options.icon_left?
          concat icon_span(options.icon_right, "is-small is-right") if options.icon_right?
        end
      end
    end

    # [Form Field](https://bulma.io/documentation/form/general/#form-field)
    # In addition to being able to add the "column" class by setting `column: true`, you can provide sizing for the
    # column by passing in the class name as a string. For example, `column: "is-one-third"` will add the class
    # "column is-one-third" to the field div.
    def wrap_with_field_and_label(object_name, method, options, suppress_label: false, column: false)
      tag.div(class: class_names(:field, column: column, column => column.is_a?(String))) do
        concat label(object_name, method, class: "label") unless suppress_label
        concat yield
      end
    end

    # [Icon](https://bulma.io/documentation/elements/icon/)
    def icon_span(icon, additional_classes = nil)
      tag.span(class: "icon #{additional_classes}".strip) do
        tag.i(class: icon)
      end
    end

    def append_classes_to_options(options, *additional_classes)
      classes = options.fetch(:class, "")
      adds = additional_classes.reject { classes.include?(it) }
      options[:class] = "#{classes} #{adds.join(' ')}".strip
    end

    def append_data_attributes_to_options(options, **additional_attributes)
      data = options.fetch(:data, {})
      options[:data] = data.merge(additional_attributes)
    end

    def attribute_has_errors?(options, attribute_name)
      object = options[:object]
      object.respond_to?(:errors) && object.errors.key?(attribute_name)
    end

    # # Input Options Parser
    #
    # Module InputOptionsParser is mixed into the options hash to provide accessors and predicate methods for the custom
    # options suppress_label, icon_left, and icon_right.
    #
    # Method `icon_control_classes` returns a hash suitable for passing to the `class_names` helper method.
    #
    # TODO: Handle options for [input modifiers color, size, and state](https://bulma.io/documentation/form/input/).
    module InputOptionsParser
      def self.extended(base)
        attr_reader :icon_left, :icon_right

        base.instance_variable_set(:@suppress_label, base.delete(:suppress_label))
        base.instance_variable_set(:@icon_left, base.delete(:icon_left))
        base.instance_variable_set(:@icon_right, base.delete(:icon_right))
        base.instance_variable_set(:@column, base.delete(:column))
      end

      def suppress_label?
        @suppress_label
      end

      def icon_left?
        @icon_left.present?
      end

      def icon_right?
        @icon_right.present?
      end

      def icon_control_classes
        { "has-icons-left": icon_left?, "has-icons-right": icon_right? }
      end

      def column?
        @column
      end
    end
  end
end
