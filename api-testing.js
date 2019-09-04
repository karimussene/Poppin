const googleTrends = require('google-trends-api');
const fs = require('fs')

const cuisines = ["Afghan", "African", "American", "Arabian", "Argentine",
 "Asian","Asian Fusion","Australian", "Austrian", "BBQ", "Bakery",
 "Bangladeshi", "Bar Food", "Basque", "Belgian", "Beverages",
 "Brasserie", "Brazilian", "British", "Bubble Tea", "Burger",
 "Burmese", "Cafe Food", "Cambodian", "Cantonese", "Caribbean",
 "Charcoal Chicken", "Chinese", "Colombian", "Continental",
 "Creole", "Crepes", "Croatian", "Cuban", "Czech", "Danish", "Deli",
 "Desserts", "Diner", "Dumplings", "Dutch", "Eastern European",
 "Ecuadorian", "Egyptian", "Ethiopian", "European", "Falafel",
 "Fast Food", "Filipino", "Finger Food", "Fish and Chips",
 "French", "Fried Chicken", "Frozen Yogurt", "Fusion",
 "German", "Greek", "Grill", "Hawaiian", "Healthy Food",
 "Hot Pot", "Hungarian", "Ice Cream", "Indian", "Indonesian",
 "Iranian", "Iraqi", "Irish", "Israeli", "Italian", "Japanese",
 "Japanese BBQ", "Kebab", "Korean", "Korean BBQ", "Laotian",
 "Latin American", "Lebanese", "Malaysian", "Meat Pie", "Mediterranean",
 "Mexican", "Middle Eastern", "Modern Australian", "Modern European",
 "Mongolian", "Moroccan", "Nepalese", "North Indian", "Oriental",
 "Pakistani", "Pan Asian", "Pastry", "Patisserie", "Peruvian",
 "Pastry", "Oriental", "Pakistani", "Pan Asian", "Pastry", "Patisserie",
 "Peruvian", "Pho", "Pizza", "Poké", "Polish", "Portuguese",
 "Ramen", "Roast", "Russian", "Salad", "Sandwich", "Satay", "Scandinavian",
 "Seafood", "Shanghai", "Sichuan", "Singaporean", "Soul Food", "South Indian",
 "Spanish", "Sri Lankan", "Steak", "Street Food", "Sushi", "Swedish",
 "Swiss", "Taiwanese", "Tapas", "Tea", "Teppanyaki", "Teriyaki", "Tex-Mex",
 "Thai", "Tibetan", "Turkish", "Turkish Pizza", "Uruguayan", "Uyghur",
 "Vegan", "Vegetarian", "Venezuelan", "Vietnamese", "Yum Cha"]
// params for the api call
let city_results = { sydney: []}
const city_map = new Map();
const start_time = new Date('2014-01-01')
const end_time = new Date ('2019-08-30')

// api call to the OFFICIAL google trends api
cuisines.forEach((cuisine) => {
  googleTrends.interestOverTime({keyword: cuisine, startTime: start_time, endTime: end_time, category: 276, geo: 'AU-NSW'})
  .then((results) => {
    const response = results
    let json_response = JSON.parse(response)
    city_results.sydney.push({[cuisine] : json_response.default})
    let city_json = JSON.stringify(city_results)
    fs.writeFile('trends-file.json', city_json, function(err){
      if (err) throw err;
      console.log('The "data to append" was appended to file!');
    }); //write local file with all entries
  })
  .catch((err) => {
  console.log(err);
  })
})


// fs.readFile('korean_food_trends_V2.json', 'utf8', function (err, data){
//     let obj = JSON.parse(data) //convert the json file to an object
//     console.log(obj)
//     query.forEach((cuisine) => {
//       // for each entry in the query array, make api calls and append to the object
//       googleTrends.interestOverTime({keyword: cuisine}) //api call
//       .then(function(results){
//         const json_response = results
//         const results_map = JSON.parse(json_response) //catch the json file
//         console.log(results_map) //check for results
//         obj.push({cuisine: results_map}); //add data to object
//         const trend_results = JSON.stringify(obj); //convert object back to json
//       })
//     fs.writeFile('trends-file.json', trend_results) //write local file with all entries
//     });
// });
