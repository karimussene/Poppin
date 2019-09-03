const searchAlgoRestau = (event) => {
  fetch("https://developers.zomato.com/api/v2.1/restaurant?res_id=16774318", {
    method: "GET",
    headers: {"user-key: 075256d88e8932de1cc05f8f16ccc44f",
              "Accept: application/json"
              }
    body: JSON.stringify({ query: event.currentTarget.value })
  })
    .then(response => response.json())
    .then((data) => {
      console.log(data); // Look at local_names.default
    });
};


export {searchAlgoRestau};


