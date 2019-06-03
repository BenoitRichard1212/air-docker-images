FROM 45air/phpfpm

RUN useradd airsnapshots && \
	mkdir -p /home/airsnapshots && \
	mkdir -p /airsnapshots && \
	chown -R airsnapshots:airsnapshots /home/airsnapshots && \
	chown -R airsnapshots:airsnapshots /airsnapshots && \
	su - airsnapshots -c "composer global require 45air/airsnapshots" \
	&& su - airsnapshots -c "composer clear-cache"

ENV PATH="/home/airsnapshots/.composer/vendor/bin:${PATH}"

COPY ./snapshots.sh /

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "sh", "-c", "trap 'echo dying; exit' SIGINT SIGTERM; while true; do sleep 2; done"]
