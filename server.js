//Install express server
const express = require('express');
const path = require('path');
const pg = require('pg');


const app = express();
const pool = new pg.Pool()

console.log(process.env.DATABASE_URL);
const dbString = process.env.DATABASE_URL;

// Serve only the static files form the dist directory
app.use(express.static(__dirname + '/dist/game-universe'));

const sharedPgClient = null;

pool.connect(dbString, function (err, client) {
    if (err) {
        console.error("PG Connection Error")
    }
    console.log("Connected to Postgres");
    sharedPgClient = client;
});


app.get("/addCompetitions", function defaultRoute(req, res) {
    var query = "SELECT * FROM Competitions.master_format";

    sharedPgClient.query(query, function (err, result) {
        console.log("Jobs Query Result Count: " + result.rows.length);
        res.send(result)
    });
});

app.get('/*', function (req, res) {

    res.sendFile(path.join(__dirname + '/dist/game-universe/index.html'));
});

app.get('/addCompetitions', function (req, res) {

    //PRoceso el data
});

// Start the app by listening on the default Heroku port
app.listen(process.env.PORT || 8080);





