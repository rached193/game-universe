//Install express server
const express = require('express');
const path = require('path');
const pg = require('pg');


const app = express();
const pool = new pg.Pool({
    user: 'xbbhrkvssfuetu',
    host: 'ec2-54-195-252-243.eu-west-1.compute.amazonaws.com',
    database: 'dcbdsmfutcv57e',
    password: 'a13806713fe574ff9dfa2288840c12ca9f66ab2579e851341a8ce87c4e2ce15c',
    port: 5432,
    ssl: true
});

// Serve only the static files form the dist directory
app.use(express.static(__dirname + '/dist/game-universe'));

var sharedPgClient = null;

pool.connect(function (err, client) {
    if (err) {
        console.error("PG Connection Error")
    }
    console.log("Connected to Postgres");
    sharedPgClient = client;
});

app.get("/addCompetitions", function defaultRoute(req, res) {
    var query = "SELECT master_data.get_videogames()";

    sharedPgClient.query(query, function (err, result) {
        console.log("Jobs Query Result Count: " + result.rows.length);
        res.send(result.rows)
    });
});


app.post("/register", (req, res) => {
    console.log("/register: ", req.body);
    var query = 'SELECT user_data.create_account(jorge, jorge, jorge) as data;';

    sharedPgClient.query(query, (err, result) => {

        console.log(err);
        console.log(result);

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

const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`Server running at ${port}`);
});




