const express = require("express");
const chokidar = require("chokidar");
const { exec } = require("child_process");
const WebSocket = require("ws");
const path = require("path");

const app = express();
const port = 3000;
const wsPort = 3001;

const pumlFile = process.argv[2];
if (!pumlFile) {
  console.error("Error: No .puml file specified.");
  process.exit(1);
}

var outputDir = "~/.config/nvim/plantuml-previewer/renders/"; 

var svgFileName = pumlFile.split('/').pop().replace('.puml', '.svg');
console.log(svgFileName);

var targetSvgFileName = outputDir + 'diagram.svg';

// WebSocket for live reload
const wss = new WebSocket.Server({ port: wsPort });
wss.on("connection", (ws) => {
  console.log("Client connected");
});

const generateSVG = (pathToPumlFile) => {
  exec(`plantuml -tsvg ${pumlFile} -o ${outputDir}`, (err, stdout, stderr) => {
    exec(`mv ${outputDir}${svgFileName} ${targetSvgFileName}`);
    if (err) {
      console.error("Error generating SVG:", stderr);
      return;
    }
    console.log("SVG updated.");
  });
};

generateSVG(pumlFile);



// Watch the .puml file and regenerate the SVG
chokidar.watch(pumlFile).on("change", () => {
  console.log(`File changed: ${pumlFile}`);
  generateSVG(pumlFile);
  // Notify WebSocket clients to reload
  wss.clients.forEach((client) => client.send("reload"));
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
});

app.get('/diagram.svg', (req, res) => {
  res.sendFile(__dirname + '/renders/diagram.svg');
})
