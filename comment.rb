class Comment
  attr_reader :username, :comment
  def initialize(username, comment)
    @username = username
    @comment = comment
  end

  def convert_to_array
    [username, comment]
  end
end
