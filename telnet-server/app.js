var net = require('net');

var sockets = [];
var sockets_data = [];

function cleanInput(data) {
    return data.toString().replace(/(\r\n|\n|\r)/gm,"");
}

function receiveData(socket, data) {
    var cleanData = cleanInput(data);
    console.log(sockets.length + "\t" + cleanData);
    if(cleanData === "@quit") {
        for(var i = 0; i<sockets_data.length; i++) {
            socket.write(sockets_data[i] + "\r\n");
        }
        socket.end('[[[status]]]: ok\n');
    } else {
        sockets_data.push(cleanData);
        for(var i = 0; i<sockets.length; i++) {
            if (sockets[i] !== socket) {
                sockets[i].write(data);
            }
        }

    }
}

function closeSocket(socket) {
    var i = sockets.indexOf(socket);
    if (i != -1) {
        sockets.splice(i, 1);
    }
}

function newSocket(socket) {
    sockets.push(socket);
    socket.write('Welcome to the Telnet server!\n');
    socket.on('data', function(data) {
        receiveData(socket, data);
    })
    socket.on('end', function() {
        closeSocket(socket);
    })
}

var server = net.createServer(newSocket);
server.listen(8888);
