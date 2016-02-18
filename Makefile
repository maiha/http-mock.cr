LINK_FLAGS = --link-flags "-static"

http-mock: src/http-mock/http-mock.cr
	crystal build src/http-mock/http-mock.cr ${LINK_FLAGS}

clean:
	rm http-mock
