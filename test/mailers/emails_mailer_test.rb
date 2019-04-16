require 'test_helper'

class EmailsMailerTest < ActionMailer::TestCase
  test "new_user" do
    mail = EmailsMailer.new_user
    assert_equal "New user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_order" do
    mail = EmailsMailer.new_order
    assert_equal "New order", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
