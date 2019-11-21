start:
	docker run -d -p 4000:4000 --env-file .env stratockaster/tailwind:0.3 bin/tailwind start