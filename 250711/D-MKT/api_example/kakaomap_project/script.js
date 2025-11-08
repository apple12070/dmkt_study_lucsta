const url =
  "https://apis.data.go.kr/B551011/GoCamping/basedList?numOfRows=4000&pageNo=1&MobileOS=ETC&MobileApp=camping&serviceKey=E6CV3rvwfPkP1o3vq2vWxBexLVSIDeUQRsGJjSpyBY1Lm800N%2B3Ie26OgNz07W24zsD%2FZj0d8HTz2VrC3g9uwA%3D%3D&_type=json";

fetch(url)
  .then((response) => response.json())
  .then((result) => {
    const data = result.response.body.items.item;
    console.log(data);
    const showPosition = (position) => {
      const { latitude, longitude } = position.coords;
      console.log(latitude, longitude);
      const container = document.getElementById("map");
      var options = {
        center: new kakao.maps.LatLng(latitude, longitude),
        level: 3,
      };

      var map = new kakao.maps.Map(container, options);

      var clusterer = new kakao.maps.MarkerClusterer({
        map: map,
        averageCenter: true,
        minLevel: 10,
      });

      let markers = [];

      for (var i = 0; i < data.length; i++) {
        var marker = new kakao.maps.Marker({
          map: map,
          position: new kakao.maps.LatLng(data[i].mapY, data[i].mapX),
        });

        markers.push(marker);

        var infowindow = new kakao.maps.Infowindow({
          content: data[i].facltNm,
        });

        function makeOverListener(map, marker, infowindow) {
          return function () {
            infowindow.open(map, marker);
          };
        }

        function makeOutListener(infowindow) {
          return function () {
            infowindow.close();
          };
        }

        kakao.maps.event.addListener(
          marker,
          "mouseover",
          makeOverListener(map, marker, infowindow)
        );

        kakao.maps.event.addListener(
          marker,
          "mouseout",
          makeOutListener(infowindow)
        );
      }

      clusterer.addMarkers();
    };

    const errorPosition = (error) => {
      alert(error.message);
    };
    window.navigator.geolocation.getCurrentPosition(
      showPosition,
      errorPosition
    );
  });
