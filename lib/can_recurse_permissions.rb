
# Just your basic find my permission / role mixin
# See http://www.adomokos.com/2012/10/the-organizations-users-roles-kata.html for background
#
# Assumptions:
# * Class being mixed into has attributes / methods role_id, parent_id, and find
# * That calling find(parent_id) with return an object representing the parent
# * That the parent is of the same Type
# * role_id defaults to nil
# * That at some point when we will get some parent with some role_id eventually even if it's the root
#
# Other notes.
# The link above mentions the root an leaves having a constant difference: this works with arbitrary depths
# Max number of queries to find an answer is == the distance from root to current object


module CanRecursePermissions

  def role
    if id = self.role_id
      role_conversion(id)
    else
      self.class.find(parent_id).role
    end
  end


  # You need to implement this to return your own role implementation whether
  # that's an object or not (take a look at the tests for a dead simple example)
  def role_conversion(id)
    raise "must implement your own role conversion method"
  end

end
