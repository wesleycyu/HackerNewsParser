class Post
  attr_reader :page, :comments_array, :title, :url, :points, :id, :comments_objects

  def initialize(url)
    @page = Nokogiri::HTML(open(url))
    (@title, @url, @points, @id) = parse_post
    @comments_array = create_comment_list
    @comments_objects = create_comment_objects
  end

  def parse_post
    [find_title, find_url, find_points, find_id]
  end

  def comments
    @comments_array.each_with_index do |comment, index|
      puts "USERNAME: #{comment[0]} | COMMENT ID: #{index}"
      puts " - - - - - - - - - - - - - - - - - - - - - - - "
      puts "COMMENT: #{comment[1]}\n\n"
    end
  end

  def new_comment
    puts "What's your username?"
    username = STDIN.gets.chomp
    puts "What comment would you like to add?"
    comment = STDIN.gets.chomp
    new_comment = Comment.new(username, comment)
    add_comment(new_comment)
  end

  def add_comment(new_comment)
    new_comment_array = new_comment.convert_to_array
    @comments_array << new_comment_array
    puts "Your comment has been added under ID number #{@comment_list.length}"
  end

  private
    def find_title
      @page.css("td.title a").text.to_s
    end

    def find_url
      @page.css("td.title a")[0]['href']
    end

    def find_points
      @page.css("span.score").text
    end

    def find_id
      @page.css("span.score")[0]['id']
    end

    def parse_users
      user_list = []
      users_names = @page.css("td.default span.comhead a:first-child")
      users_names.each do |row|
        user_list << row.text
      end
      user_list
    end

    def parse_comment_text
      comments_list = []
      comments = @page.css("font")
      comments.each do |row|
        comments_list << row.text
      end
      comments_list.delete("-----")
      comments_list.delete("\n                      -----\n                  ")
      comments_list
    end

    def create_comment_list
      parse_users.zip(parse_comment_text)
    end

    def create_comment_objects
      output = []
      @comments_array.each_with_index do |comment, index|
        output << Comment.new(comment[0],comment[1])
      end
      output
    end
end