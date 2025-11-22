require "test_helper"
require "minitest/mock"

require_relative "../../../app/helpers/bulma/form_helper"

module Bulma
  module TagOutputAssertions
    def assert_html_equal(expected, actual, message = nil)
      # First try the normal DOM comparison
      begin
        assert_dom_equal(expected, actual, message)
      rescue Minitest::Assertion => e
        # If the DOM comparison fails, format the HTML for better readability
        expected_formatted = format_html(expected)
        actual_formatted = format_html(actual)

        # Now do a string comparison which will automatically generate a nice diff
        assert_equal expected_formatted, actual_formatted, message
      end
    end

    # Helper method to format HTML with proper indentation
    def format_html(html)
      # Parse and re-serialize the HTML with indentation
      Nokogiri::HTML.fragment(html).to_xhtml(indent: 2)
    end
  end

  class TestUser
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string
    attribute :password, :string
    attribute :bio, :string
    attribute :admin, :boolean
    attribute :avatar, :string
    attribute :role, :string

    validates :email, presence: true
  end

  class FormHelperTest < ActionView::TestCase
    include FormHelper
    include TagOutputAssertions

    setup do
      @user = TestUser.new(name: "Test User", email: "test@example.com")
    end

    test "text_field with default options" do
      result = text_field(:user, :name, object: @user)

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_name">Name</label>
          <div class="control">
            <input class="input" type="text" name="user[name]" id="user_name" value="Test User" />
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "text_field with suppressed label" do
      result = text_field(:user, :name, object: @user, suppress_label: true)

      expected = <<~HTML
        <div class="field">
          <div class="control">
            <input class="input" type="text" name="user[name]" id="user_name" value="Test User" />
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "text_field with left icon" do
      result = text_field(:user, :email, object: @user, icon_left: "fas fa-envelope")

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_email">Email</label>
          <div class="control has-icons-left">
            <input class="input" type="text" name="user[email]" id="user_email" value="test@example.com" />
            <span class="icon is-small is-left"><i class="fas fa-envelope"></i></span>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "text_field with right icon" do
      result = text_field(:user, :email, object: @user, icon_right: "fas fa-check")

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_email">Email</label>
          <div class="control has-icons-right">
            <input class="input" type="text" name="user[email]" id="user_email" value="test@example.com" />
            <span class="icon is-small is-right"><i class="fas fa-check"></i></span>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "text_field with both icons" do
      result = text_field(:user, :email, object: @user, icon_left: "fas fa-envelope", icon_right: "fas fa-check")

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_email">Email</label>
          <div class="control has-icons-left has-icons-right">
            <input class="input" type="text" name="user[email]" id="user_email" value="test@example.com" />
            <span class="icon is-small is-left"><i class="fas fa-envelope"></i></span>
            <span class="icon is-small is-right"><i class="fas fa-check"></i></span>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "password_field" do
      result = password_field(:user, :password, object: @user)

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_password">Password</label>
          <div class="control">
            <input class="input" type="password" name="user[password]" id="user_password" />
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "email_field" do
      result = email_field(:user, :email, object: @user)

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_email">Email</label>
          <div class="control">
            <input class="input" type="email" name="user[email]" id="user_email" value="test@example.com" />
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "select field" do
      result = select(:user, :role, [ "Admin", "User" ], { object: @user })

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_role">Role</label>
          <div class="control">
            <div class="select">
              <select name="user[role]" id="user_role">
                <option value="Admin">Admin</option>
                <option value="User">User</option>
              </select>
            </div>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "select field with column" do
      result = select(:user, :role, [ "Admin", "User" ], { object: @user, column: true })

      expected = <<~HTML
        <div class="field column">
          <label class="label" for="user_role">Role</label>
          <div class="control">
            <div class="select">
              <select name="user[role]" id="user_role">
                <option value="Admin">Admin</option>
                <option value="User">User</option>
              </select>
            </div>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "checkbox" do
      result = I18n.stub :translate, "Admin", [ :admin, { scope: [ "helpers", "label", :user ], default: "Admin" } ] do
        checkbox(:user, :admin, { object: @user }, "1", "0")
      end

      expected = <<~HTML
        <div class="field">
          <div class="control">
            <label class="checkbox"  for="user_admin">
              <input type="hidden" name="user[admin]" value="0" autocomplete="off" />
              <input type="checkbox" value="1" name="user[admin]" id="user_admin" />
              Admin
            </label>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "file_field" do
      result = I18n.stub :translate, "Avatar", [ :avatar, { scope: [ "helpers", "label", :user ], default: "Avatar" } ] do
        file_field(:user, :avatar, object: @user, accept: "image/png,image/jpeg")
      end

      expected = <<~HTML
        <div class="file is-boxed" data-controller="bulma--file-input-display" data-bulma--file-input-display-accepted-file-types-value="[&quot;image/png&quot;,&quot;image/jpeg&quot;]">
          <label class="file-label">
            <input accept="image/png,image/jpeg" class="file-input" type="file" name="user[avatar]" id="user_avatar"
                  data-bulma--file-input-display-target="fileInput"
                  data-action="bulma--file-input-display#show" />
            <span class="file-cta">
              <span class="file-icon"><i class="fas fa-upload"></i></span>
              <span class="file-label">Avatar</span>
            </span>
            <div class="content" data-bulma--file-input-display-target="fileList">No file(s) selected</div>
          </label>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "textarea" do
      result = textarea(:user, :bio, object: @user)

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_bio">Bio</label>
          <div class="control">
            <textarea class="textarea" name="user[bio]" id="user_bio"></textarea>
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end

    test "submit_tag" do
      result = submit_tag("Save")

      expected = <<~HTML
        <div class="control">
          <input type="submit" name="commit" value="Save" class="button" data-disable-with="Save" />
        </div>
      HTML

      assert_html_equal expected, result
    end
  end

  # This shows the result when the field_error_proc is changed to just return the tag
  class FormHelperWithoutFieldErrorProcTest < ActionView::TestCase
    include FormHelper
    include TagOutputAssertions

    def setup
      @original_field_error_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |html_tag, _| html_tag.html_safe }
    end

    def teardown
      ActionView::Base.field_error_proc = @original_field_error_proc
    end

    test "text_field with error" do
      user_with_errors = TestUser.new(name: "Invalid User")
      user_with_errors.validate

      result = text_field(:user, :email, object: user_with_errors)

      expected = <<~HTML
        <div class="field">
          <label class="label" for="user_email">Email</label>
          <div class="control">
            <input class="input is-danger" type="text" name="user[email]" id="user_email" />
          </div>
        </div>
      HTML

      assert_html_equal expected, result
    end
  end
end
