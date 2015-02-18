Auth = (function () {
  function Auth() {}

  Auth.prototype.authenticate = function (username, password, callback) {
    var Client = Npm.require('ssh2').Client,
        conn = new Client();

    conn.on('ready', function () {
      callback(null, true);
    });
    conn.on('error', function (e) {
      callback(e);
    });
    conn.on('keyboard-interactive', function (name, instructions, instructionsLang, prompts, finish) {
      finish([password]);
    });

    conn.connect({
      host: 'astral.central.cranfield.ac.uk',
      port: 22,
      username: username,
      tryKeyboard: true
    });
  };

  return Auth;

})();
