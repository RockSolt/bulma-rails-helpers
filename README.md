[![Gem Version](https://badge.fury.io/rb/bulma-rails-helpers.svg)](https://badge.fury.io/rb/bulma-rails-helpers)
[![Tests](https://github.com/rocksolt/bulma-rails-helpers/actions/workflows/test.yml/badge.svg)](https://github.com/rocksolt/bulma-rails-helpers/actions/workflows/test.yml)
[![RuboCop](https://github.com/rocksolt/bulma-rails-helpers/actions/workflows/rubocop.yml/badge.svg)](https://github.com/rocksolt/bulma-rails-helpers/actions/workflows/rubocop.yml)

# Building Rails Forms for Bulma

CSS libraries tend to have opinions about HTML. Remember the first time someone explained CSS to you,
and that it was this magical thing that could change the look and feel without any changes to the
HTML? Alas, the idea was good in theory. In practice, there's a `div` around that thing for one
library. It's got two `span` elements in the other. And on, and on...

But the idea that a view can be written once then have its look and feel modified by CSS still has
appeal. That is one of the drivers behind this library.

The other idea is that the view should be config. Design, both UI and UX, is important, but get it
done and out of the way of the view file. When a view simply lists the fields on the form, it is
easy to build and easy to maintain.

There are two main things to know about the Bulma Rails Helpers library:
- each input field gets a label by default
- it overrides the Rails tag helpers

That last one is a big deal. This is not a gem that should be used lightly. It is purposely heavy
handed so that the results are consistent. There are other, lighter solutions; this is not one of them.


## Usage

Here's what a Rails generator might produce:

```erb
  <div>
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>
  <div>
    <%= form.label :author %>
    <%= form.text_field :author %>
  </div>
```

All that really says is put a text field for title and a text field for author, each with labels.
Here is what that looks like using this gem:

```erb
<%= form.text_field :title %>
<%= form.text_field :author %>
```

And here is the resulting HTML wrapped with the structure that Bulma is looking for:

```html
<div class="field">
  <label class="label" for="post_title">Title</label>
  <div class="control">
    <input class="input" type="text" name="post[title]" id="post_title" value="Building Rails Forms for Bulma" />
  </div>
</div>

<div class="field">
  <label class="label" for="post_author">Author</label>
  <div class="control">
    <input class="input" type="text" name="post[author]" id="post_author" value="Todd" />
  </div>
</div>
```

It looks very similar to what Rails generates. In fact, both the `label` and the `input` tags are built
by the Rails tag helpers. Once the Bulma-friendly wrappers have been added, things are turned over
to Rails.

All of the Rails form helpers are supported / overridden.

In addition to the standard options, the following options are supported for inputs:

- suppress_label: Do not render the label tag
- icon_left: Add an icon to the left of the input field
- icon_right: Add an icon to the right of the input field

The two icon options should be a string that represents the icon class. For example, "fas fa-user" would render a user
icon from Font Awesome.

### Labels

This delegates the work of determining the label text to
[the Rails form helper](https://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-label).

> The text of label will default to the attribute name unless a translation is found in the current I18n locale (through `helpers.label.<modelname>.<attribute>`).

The label cannot be specified explicitly.

### Help the Helpers

In addition to the override of Rails helpers, the following helpers are available. They are used by
the overrides to generate content in a Bulma-friendly way:

**[Form Control](https://bulma.io/documentation/form/general/#form-control)**

Helper `wrap_with_control` does just that, adding a `div` element with the class `control` then
yielding.

**[Form Field](https://bulma.io/documentation/form/general/#form-field)**

Helper `wrap_with_field_and_label(object_name, method, options, suppress_label: false, column: false)`
adds the label then wraps both the label and the input with a `div` element with the class `field`.
The first three arguments are the standard Rails tag helper arguments.

The `suppress_label` and `column` keyword arguments can be passed as options to any of the input
helpers and will be evaluated here.

In addition to being able to add the ["column" class](https://bulma.io/documentation/columns/basics/)
by setting `column: true`, you can provide sizing for the column by passing in the class name as a
string. For example, `column: "is-one-third"` will add the class "column is-one-third" to the field div.

**[Icon](https://bulma.io/documentation/elements/icon/)**

Helper `icon_span(icon, additional_classes = nil)` adds an icon. The first argument is the class
that defines the icon; the second optional argument allows size and/or position to be specified.

**[Form Input](https://bulma.io/documentation/form/general/#complete-form-example)**

Helper `wrap_input_field(object_name, method, options)` is the starting point for the input helper
overrides and does the following:

- adds class `is-danger` if the attribute has an error
- invokes `wrap_with_field_and_label`
- invokes `icon_span` if an icon has been specified


### JavaScript

The following Stimulus controllers implement the JavaScript suggested by the Bulma library:

**[Dropdown Controller](https://bulma.io/documentation/components/dropdown/#hoverable-or-toggable)**

This controller can be added to a Bulma Dropdown to make it clickable.

```html
<div class="dropdown" data-controller="bulma--dropdown">
  <div class="dropdown-trigger">
    <button class="button" data-action="bulma--dropdown#toggle">...</button>
  </div>
  <div class="dropdown-menu" role="menu">...</div>
</div>
```

**[File Input Display Controller](https://bulma.io/documentation/form/file/#javascript)**

This controller is added when the `file_field` helper is invoked. It restricts the file types that
can be selected and shows the file names.

**[Navigation Bar Controller](https://bulma.io/documentation/components/navbar/)**

There are no helpers for the Bulma Navbar, but this controller can be added to provide the suggested
toggle.


## Installation
Add this line to your application's Gemfile:

```ruby
gem "bulma-rails-helpers"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bulma-rails-helpers
```

> [!IMPORTANT]
> This library *does NOT include Bulma*. You must include that separately.

### Importmap Support

This works with Rails Importmap out of the box. It has not been tested with any other Javascript
loaders.

## Contributing

Feedback and contributions are welcome. Anything missing? Anthing that would be helpful to have?

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

This leverages [the Bulma CSS library](https://bulma.io/documentation/) but is not endorsed or
certified by Bulma. We are fans of the library and this makes using it in Rails a bit easier.