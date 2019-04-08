//Install express server
const express = require('express');
const path = require('path');
const pg = require('pg');


const app = express();
const pool = new pg.Pool({
    user: 'ebiypfwrqgauhd',
    host: 'ec2-54-247-70-127.eu-west-1.compute.amazonaws.com',
    database: 'db52vg2qmaqvaj',
    password: '450b56f7a62ec0fd1024d07d13e715c101082caf81878a9507b0657b58ebe6ac',
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
    var query = "SELECT * FROM Competitions.master_format";

    sharedPgClient.query(query, function (err, result) {
        console.log("Jobs Query Result Count: " + result.rows.length);
        res.send(result.rows)
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




