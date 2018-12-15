start:
	docker-compose up

drop_db:
	docker-compose run app rake db:drop

create_db:
	docker-compose run app rake db:create

migrate_db:
	docker-compose run app rake db:migrate

seed_db:
	docker-compose run app rake db:seed

routes:
	docker-compose run app rake routes

bundle_app:
	docker-compose run bundle install

bundle_job:
	docker-compose run bundle install
