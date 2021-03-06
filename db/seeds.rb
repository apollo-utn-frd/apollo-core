# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

return unless Rails.env.development?
return if User.exists?

batman = User.create!(
  username: 'batman',
  provider: 'google_oauth2',
  google_id: 117610751969512663627,
  email: 'federicohernansanches@gmail.com',
  name: 'Bruce',
  lastname: 'Wayne',
  gender: 'male',
  image_url: 'https://drive.google.com/uc?export=view&id=0B0UwIYETUqQJa2pNSUY5cXFjZXc',
  description: 'I\'m Batman',
  confirmed: true
)

flash = User.create!(
  username: 'flash',
  provider: 'google_oauth2',
  google_id: 1236,
  email: 'flash@gmail.com',
  name: 'Barry',
  lastname: 'Allen',
  gender: 'male',
  image_url: 'https://drive.google.com/uc?export=view&id=0B0UwIYETUqQJV2Z2Y0szc0RoYlU',
  description: 'The fastest man alive',
  confirmed: true
)

arrow = User.create!(
  username: 'arrow',
  provider: 'google_oauth2',
  google_id: 1237,
  email: 'arrow@gmail.com',
  name: 'Oliver',
  lastname: 'Queen',
  gender: 'male',
  image_url: 'https://drive.google.com/uc?export=view&id=0B0UwIYETUqQJZzhRQW5FTVFXVWc',
  description: 'You have failed this city',
  confirmed: true
)

raven = User.create!(
  username: 'raven',
  provider: 'google_oauth2',
  google_id: 1238,
  email: 'raven@gmail.com',
  name: 'Rachel',
  lastname: 'Roth',
  gender: 'female',
  image_url: 'https://drive.google.com/uc?export=view&id=0B0UwIYETUqQJOTVDeDJ2MWdwTTQ',
  description: 'Azarath Metreon Zinthos',
  confirmed: true
)

batman.follow!(arrow)
batman.follow!(flash)
flash.follow!(arrow)
arrow.follow!(batman)

ruta_entrenamiento = Travel.create!(
  title: 'Mi entrenamiento diario',
  description: 'Descripcion de prueba',
  user: flash,
  places_attributes: [
    {
      title: 'Federal Bureau of Investigation',
      coordinates: 'POINT(-74.004044 40.716014)'
    },
    {
      title: 'Confederate Park',
      coordinates: 'POINT(-81.653448 30.333877)'
    }
  ]
)

batman.favorite!(ruta_entrenamiento)
arrow.favorite!(ruta_entrenamiento)
flash.favorite!(ruta_entrenamiento)

Comment.create!(
  user: flash,
  travel: ruta_entrenamiento,
  content: 'Un buen dia para ejercitarse'
)

flashcueva = Travel.create!(
  title: 'Ubicacion de la Flashcueva',
  description: 'Otra descripcion mas de prueba',
  user: flash,
  publicx: false,
  places_attributes: [
    {
      title: 'Flashcueva',
      coordinates: 'POINT(6.9475 50.335556)'
    }
  ]
)

flashcueva.authorize!(batman)
batman.favorite!(flashcueva)

Comment.create!(
  user: batman,
  travel: flashcueva,
  content: 'Guardare el secreto'
)

arrowcueva = Travel.create!(
  title: 'Ubicacion de la Arrowcueva',
  description: 'La 4ta descripcion de prueba',
  user: arrow,
  publicx: false,
  places_attributes: [
    {
      title: 'Arrowcueva',
      description: 'Mansion Queen',
      coordinates: 'POINT(129.738333 32.627778)'
    }
  ]
)

arrowcueva.authorize!(flash)

Comment.create!(
  user: flash,
  travel: arrowcueva,
  content: 'Voy corriendo para alla'
)

triangulo_bermudas = Travel.create!(
  title: 'Triangulo de las Bermudas',
  description: 'La 5ta descripcion de prueba',
  user: raven,
  places_attributes: [
    {
      title: 'Primer vertice',
      coordinates: 'POINT(-80.226529 25.789106)'
    },
    {
      title: 'Segundo vertice',
      coordinates: 'POINT(-66.1057427 18.4663188)'
    },
    {
      title: 'Tercer vertice',
      coordinates: 'POINT(-64.781380 32.294887)'
    },
    {
      title: 'Primer vertice otra vez',
      coordinates: 'POINT(-80.226529 25.789106)'
    }
  ]
)

arrow.favorite!(triangulo_bermudas)
flash.favorite!(triangulo_bermudas)

lugares_energeticos = Travel.create!(
  title: 'Lugares con energia positiva',
  description: 'La 6ta descripcion de prueba',
  user: raven,
  places_attributes: [
    {
      title: 'Atucha',
      coordinates: 'POINT(-59.2069292 -33.9668613)'
    },
    {
      title: 'Itaipu',
      coordinates: 'POINT(-54.590303 -25.407217)'
    },
    {
      title: 'Parque Eolico Monte redondo',
      coordinates: 'POINT(-71.613073 -31.061510)'
    }
  ]
)

batman.favorite!(lugares_energeticos)
arrow.favorite!(lugares_energeticos)
flash.favorite!(lugares_energeticos)

Travel.create!(
  title: 'Ubicacion de la Baticueva',
  description: 'Una descripcion de prueba',
  user: batman,
  publicx: false,
  places_attributes: [
    {
      title: 'Baticueva',
      description: 'Mansion Wayne',
      coordinates: 'POINT(-58.779053 -34.368214)'
    }
  ]
)
