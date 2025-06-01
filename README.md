Stworzyłem pipeline w GitHub Actions, który:
1. Buduje obraz z Dockerfile dla amd64 i arm64

2. Wysyła/pobiera cache buildów z Docker Huba (godefrey/weather-app-buildcache:cache)

3. Pushuje tymczasowy tag cibuild-SHA do GHCR

4. Skanuje obraz Trivy (CRITICAL i HIGH)

5. Jeśli nie wykryto poważnych CVE, pushuje finalne tagi latest i SHA do GHCR



Tagowanie:

cibuild-SHA – tymczasowy tag do skanowania po każdym commicie

latest – najnowszy stabilny obraz dla użytkowników

SHA – odwołanie do konkretnego commita

Cache: godefrey/weather-app-buildcache:cache – przyspieszenie kolejnych buildów



Uzasadnienie:

Cache na Docker Hub:
– Dokumentacja wskazuje, że registry jako cache pozwala na szybkie pobieranie warstw bez limitów GHCR (źródło: Docker Docs – BuildKit caching)

Trivy:
– Wybrałem Trivy, bo jest prosty do konfiguracji w GH Actions i szybko wykrywa CVE (źródło: Trivy GitHub – aquasecurity/trivy)

Tag SHA:
– Umożliwia precyzyjne odtworzenie obrazu z danego commita



Jak to działa:

checkout repo (actions/checkout@v4)

setup-qemu i setup-buildx (docker/setup-qemu-action@v3, docker/setup-buildx-action@v3)

logowanie do Docker Hub i GHCR (docker/login-action@v2)

build+push “cibuild-SHA” (docker/build-push-action@v4, push: true)

skan Trivy (aquasecurity/trivy-action@0.22.0)

jeśli skan OK, build+push finalne tagi (latest i SHA)



Potwierdzenie działania:

Uruchomiłem workflow ręcznie

Status zielony w zakładce Actions

Obrazy z odpowiednimi tagami dostępne w GHCR