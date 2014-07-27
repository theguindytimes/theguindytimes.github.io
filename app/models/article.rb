class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  searchkick word_start: [:title,:author],autocomplete: [:title,:author]

  def slug_candidates
    [
      :title,
      [:title, :id],
    ]
  end
  acts_as_taggable 
  acts_as_taggable_on :author

  def first_pic
    img_srcs=[]
    require 'nokogiri'
    doc = Nokogiri::HTML( self.content )
    img_srcs = doc.css('img').map{ |i| i['src'] }
    if img_srcs.length == 0
      img_srcs=['']
    end
    img_srcs[0]
  end

  def filtered_content
    img_srcs=[]
    require 'nokogiri'
    doc = Nokogiri::HTML( self.content )
    img_srcs = doc.css('img')
    if img_srcs.length == 0
      img_srcs=['']
      return self.content
    end
    # self.content[img_srcs[0]]=""
    # tags = self.content.scan(/<img.*>/)
    # tags.each do |i|
    #   self.content[i] = ""
    # end
    # tags = self.content.scan(/<p.*>&nbsp;<\/p>/)
    # tags.each do |i|
    #   self.content[i] = ""
    # end

    # print tags.to_json
    # tags = self.content.scan(/style=".*"/)
    # tags.each do |i|
    #   self.content[i] = ""
    # end
    tags = self.content.scan(/<p.*>.*<\/p>/)
    tags.each do |i|
      if i.length>400
        i.scan(/style=".*"/).each do |x|
          i[x] = ''
        end
        self.content = i
      end
    end
    self.content
  end

end
