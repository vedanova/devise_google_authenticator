require 'test_helper'
require 'integration_tests_helper'

class InvitationTest < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false

  def teardown
    Capybara.reset_sessions!
    Timecop.return
  end

  test 'visit recovery codes page and download the recovery codes' do
    sign_in_as_user
    visit user_recovery_codes_path
    click_link "Download codes"
  end

  test 'login using a recovery code' do
    testuser = create_and_signin_gauth_user
    click_on "Enter a recovery code"
    fill_in 'user_gauth_recovery_code', with: testuser.reload.gauth_recovery_codes.first
    click_on "Verify"
    assert_equal root_path, current_path
    assert_equal 19, testuser.reload.gauth_recovery_codes.length
  end

  test 'login using an invalid recovery code' do
    testuser = create_and_signin_gauth_user
    click_on "Enter a recovery code"
    fill_in 'user_gauth_recovery_code', with: "xyz"
    click_on "Verify"
    assert_not_equal root_path, current_path
    assert_equal new_user_session_path, current_path
  end

end