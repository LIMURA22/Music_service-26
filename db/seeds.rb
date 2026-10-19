

@raw_text = "Медиасервис для музыкантов — платформа, где гитаристы, пианисты, вокалисты и продюсеры делятся теорией музыки, лайфхаками, разборами приёмов, гайдами по DAW и получают обратную связь по своим трекам."
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

def seed
  reset_db
  create_users(3)
  create_tags
  create_posts(12)
  create_comments(2..5)
end

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def create_sentence
  sentence_words = []
  (10..20).to_a.sample.times do
    sentence_words << @words.sample
  end
  sentence_words.join(' ').capitalize + '.'
end

def create_users(quantity)
  quantity.times do |i|
    user = User.create(
      email: "user#{i + 1}@music-service.com",
      password: "Password123",
      password_confirmation: "Password123",
      admin: i.zero?
    )
    puts "User with id #{user.id} just created (admin: #{user.admin})"
  end
end

def upload_random_image
  uploader = PostImageUploader.new(Post.new, :post_image)
  # Проверка, есть ли картинки в папке, чтобы сиды не упали
  images = Dir.glob(File.join(Rails.root, 'public/autoupload/posts', '*'))
  if images.any?
    uploader.cache!(File.open(images.sample))
  end
  uploader
end

def create_tags
  tags = ["новичкам", "флажолет", "сведение", "reaper", "теория", "лайфхаки", "обзор"]
  tags.each do |tag_name|
    Tag.find_or_create_by(name: tag_name)
  end
  puts "Tags created"
end

def create_posts(quantity)
  authors = User.where(admin: false).to_a
  tags = Tag.all.to_a

  quantity.times do
    post = Post.create(
      title: create_sentence,
      description: create_sentence,
      user_id: authors.sample.id,
      status: 'approved',
      post_image: upload_random_image
    )
    
    # Прикрепляем к посту от 1 до 3 случайных тегов
    if tags.any?
      post.tags << tags.sample(rand(1..3))
    end

    puts "Post with id #{post.id} just created by user #{post.user_id} with tags"
  end
end

def create_comments(quantity)
  users = User.all.to_a
  Post.all.each do |post|
    quantity.to_a.sample.times do
      comment = Comment.create(
        post_id: post.id, 
        body: create_sentence,
        user_id: users.sample.id # Привязываем комментарий к случайному юзеру
      )
      puts "Comment with id #{comment.id} for post with id #{comment.post.id} just created"
    end
  end
end

seed