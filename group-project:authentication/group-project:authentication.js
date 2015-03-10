Auth = (function () {
  function Auth() {}

  Auth.prototype.authenticate = function (username, password, callback) {
    var Client = Npm.require('ssh2').Client,
        conn = new Client();

    conn.on('ready', Meteor.bindEnvironment(function () {
      callback(null, true);
    }));
    conn.on('error', Meteor.bindEnvironment(function (e) {
      console.log(e);
      if (e.name == "Invalid username") {
        return callback(null, false);
      }
      callback(e);
    }));
    conn.on('keyboard-interactive', function (name, instructions, instructionsLang, prompts, finish) {
      finish([password]);
    });
    try {
    conn.connect({
      host: 'astral.central.cranfield.ac.uk',
      port: 22,
      username: username,
      tryKeyboard: true
    });
    } catch (e) {
      console.log(e);
      if (e.message == "Invalid username") {
        return callback(null, false);
      }
      callback(e);
    }
  };

  return Auth;

})();
