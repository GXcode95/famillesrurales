# Seed de donnees de demo pour tests manuels CRUD.
# Idempotent: relancer ce fichier ne cree pas de doublons pour les memes noms/titres.

puts "Seeding resources..."
require "stringio"

categories = [
  "Sport",
  "Culture",
  "Jeunesse",
  "Numerique"
].map { |name| Category.find_or_create_by!(name:) }
categories_by_name = categories.index_by { |c| c.name.to_s.downcase }

staff_data = [
  { name: "Alice Martin", email: "alice.staff@example.com", job: "Coordinatrice", phone: "0600000001" },
  { name: "Bruno Leroy", email: "bruno.staff@example.com", job: "Animateur", phone: "0600000002" },
  { name: "Claire Dupont", email: "claire.staff@example.com", job: "Secretaire", phone: "0600000003" }
]
staff_data.each do |attrs|
  staff = Staff.find_or_initialize_by(email: attrs[:email])
  staff.update!(attrs)
end

activities_data = [
  {
    name: "Atelier theatre enfants",
    category_name: "Culture",
    manager_email: "theatre.manager@example.com",
    manager_name: "Emma Rossi",
    manager_phone: "0611111111",
    teacher_name: "Paul Scene",
    pricing: 95.0,
    start_date: Date.current + 7,
    end_date: Date.current + 90,
    start_time: "14:00",
    end_time: "16:00",
    info: "Initiation et mise en scene pour enfants de 8 a 12 ans."
  },
  {
    name: "Cours de yoga adultes",
    category_name: "Sport",
    manager_email: "yoga.manager@example.com",
    manager_name: "Nina Souffle",
    manager_phone: "0622222222",
    teacher_name: "Lina Zen",
    pricing: 120.0,
    start_date: Date.current + 3,
    end_date: Date.current + 120,
    start_time: "18:30",
    end_time: "20:00",
    info: "Seances hebdomadaires tout niveau."
  },
  {
    name: "Club robotique ados",
    category_name: "Numerique",
    manager_email: "robot.manager@example.com",
    manager_name: "Theo Circuit",
    manager_phone: "0633333333",
    teacher_name: "Maya Code",
    pricing: 150.0,
    start_date: Date.current + 10,
    end_date: Date.current + 100,
    start_time: "10:00",
    end_time: "12:00",
    info: "Construction de robots et programmation."
  },
  {
    name: "Aide aux devoirs college",
    category_name: "Jeunesse",
    manager_email: "devoirs.manager@example.com",
    manager_name: "Julie Aide",
    manager_phone: "0644444444",
    teacher_name: "Marc Soutien",
    pricing: 60.0,
    start_date: Date.current + 5,
    end_date: Date.current + 80,
    start_time: "17:00",
    end_time: "18:30",
    info: "Accompagnement scolaire en petit groupe."
  }
]

activities_data.each do |attrs|
  category_name = attrs.fetch(:category_name)
  category = categories_by_name[category_name.downcase] || Category.find_by!(name: category_name)
  activity_attrs = attrs.except(:category_name)

  activity = Activity.find_or_initialize_by(name: activity_attrs[:name])
  activity.assign_attributes(activity_attrs.merge(category:))
  activity.save!
end

events_data = [
  {
    name: "Forum des associations",
    body: "Rencontre avec les associations locales et inscriptions.",
    date: Time.current + 14.days
  },
  {
    name: "Soiree cine-debat",
    body: "Projection suivie d'un echange convivial.",
    date: Time.current + 21.days
  },
  {
    name: "Marche solidaire",
    body: "Parcours familial et collecte de dons.",
    date: Time.current + 30.days
  }
]

events = events_data.map do |attrs|
  event = Event.find_or_initialize_by(name: attrs[:name])
  event.update!(attrs)
  event
end

posts_data = [
  {
    title: "Reprise des activites 2026",
    body: "Les inscriptions sont ouvertes pour la nouvelle saison."
  },
  {
    title: "Nouveaux ateliers numeriques",
    body: "Decouvrez nos nouvelles sessions dediees au code et a la robotique."
  },
  {
    title: "Benevoles recherches",
    body: "Nous recherchons des benevoles pour accompagner les sorties."
  }
]

posts = posts_data.map do |attrs|
  post = Post.find_or_initialize_by(title: attrs[:title])
  post.update!(attrs)
  post
end

comment_sources = posts + events
comment_sources.each do |record|
  Comment.find_or_create_by!(
    commentable: record,
    author: "Visiteur",
    email: "visiteur@example.com",
    content: "Super initiative !"
  )
  Comment.find_or_create_by!(
    commentable: record,
    author: "Parent",
    email: "parent@example.com",
    content: "Merci pour l'organisation."
  )
end

%w[sport culture jeunesse numerique famille].each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end

seed_user = User.first
if seed_user
  gallery_targets = [posts.first, posts.second, events.first, events.second].compact
  gallery_targets.each_with_index do |target, idx|
    photo = GalleryPhoto.find_or_initialize_by(user: seed_user, attachable: target)
    if photo.new_record?
      photo.image.attach(
        io: StringIO.new("seed-image-#{idx}"),
        filename: "seed-#{idx + 1}.png",
        content_type: "image/png"
      )
      photo.save!
    end
    photo.assign_tags_from_string(idx.even? ? "famille, culture" : "sport, jeunesse")
  end
else
  puts "Aucun user existant: photos de galerie non creees (ressource dependante d'un user)."
end

puts "Seed termine."
