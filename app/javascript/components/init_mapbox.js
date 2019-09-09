import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const fitMapToMarkers = (map, features) => {
  const bounds = new mapboxgl.LngLatBounds();
  features.forEach(({ geometry }) => bounds.extend(geometry.coordinates));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
  // markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  // map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
      // style: 'mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb'
    });

  map.on('load', function() {
      const restaurants = JSON.parse(mapElement.dataset.restaurants);
      map.addSource('restaurants', {
        type: 'geojson',
        data: restaurants,
        cluster: true,
        clusterMaxZoom: 14,
        clusterRadius: 50
      });

      map.addLayer({
        id: 'clusters',
        type: 'circle',
        source: 'restaurants',
        filter: ['has', 'point_count'],
        paint: {
          'circle-color': [
            'step',
            ['get', 'point_count'],
            '#51bbd6',
            100,
            '#f1f075',
            750,
            '#f28cb1'
          ],
          'circle-radius': [
            'step',
            ['get', 'point_count'],
            20,
            100,
            30,
            750,
            40
          ]
        }
      });

      map.addLayer({
        id: 'cluster-count',
        type: 'symbol',
        source: 'restaurants',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
          'text-size': 12
        }
      });

      map.addLayer({
        id: 'unclustered-point',
        type: 'circle',
        source: 'restaurants',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': '#11b4da',
          'circle-radius': 10,
          'circle-stroke-width': 1,
          'circle-stroke-color': '#fff'
        }
      });

      map.on('click', 'clusters', function (e) {
        const features = map.queryRenderedFeatures(e.point, { layers: ['clusters'] });
        const clusterId = features[0].properties.cluster_id;

        map.getSource('restaurants').getClusterExpansionZoom(clusterId, function (err, zoom) {
          if (err) return;

          map.easeTo({
            center: features[0].geometry.coordinates,
            zoom: zoom
          });
        });
      });

      map.on('mouseenter', 'clusters', function (e) {
        map.getCanvas().style.cursor = 'pointer';
      });

      map.on('mouseleave', 'clusters', function () {
        map.getCanvas().style.cursor = '';
      });

      map.on('click', 'unclustered-point', function (e) {
        const features = map.queryRenderedFeatures(e.point, { layers: ['unclustered-point'] });
        const infoWindow = features[0].properties.info_window;
        const coordinates = features[0].geometry.coordinates;

        map.easeTo({
          center: features[0].geometry.coordinates
        });

        new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(infoWindow)
          .addTo(map);
      });

      map.on('mouseenter', 'unclustered-point', function () {
        map.getCanvas().style.cursor = 'pointer';
      });

      map.on('mouseleave', 'unclustered-point', function () {
        map.getCanvas().style.cursor = '';
      });

      fitMapToMarkers(map, restaurants.features);
    });
  }





  //   const markers = JSON.parse(mapElement.dataset.markers);
  //   markers.forEach((marker) => {
  //     const popup = new mapboxgl.Popup().setHTML(marker.infoWindow); // add this

  //     new mapboxgl.Marker()
  //       .setLngLat([ marker.lng, marker.lat ])
  //       .setPopup(popup) // add this
  //       .addTo(map);
  //   });

  //   fitMapToMarkers(map, markers);
  //   map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken }));
  // }

};

export { initMapbox };
