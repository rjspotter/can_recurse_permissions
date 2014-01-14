require 'helper'

class TestCanRecursePermissions < MiniTest::Test

  TestOrganization = Struct.new(:role_id, :parent_id) do
    def self.find
    end

    include CanRecursePermissions

    def role_conversion(id)
      ['Denied', 'User', 'Admin'][id]
    end
  end

  def test_errors_if_incomplete
    incomplete_org = Struct.new(:role_id, :parent_id) {include CanRecursePermissions}.
      new(2,0)
    exception = assert_raises(RuntimeError) {incomplete_org.role}
    assert_equal "must implement your own role conversion method", exception.message
  end

  def test_return_role_if_set
    organization = TestOrganization.new(2,0)
    assert_equal "Admin", organization.role
  end

  def test_inherits_role_from_parent_not_sibling
    parent_organization = TestOrganization.new(2,0)
    child_organization = TestOrganization.new(nil,1)
    sibling_organization = TestOrganization.new(1,1)

    TestOrganization.stub(:find, parent_organization) do
      assert_equal parent_organization.role, child_organization.role
      refute_equal sibling_organization.role, child_organization.role
    end
  end

end
