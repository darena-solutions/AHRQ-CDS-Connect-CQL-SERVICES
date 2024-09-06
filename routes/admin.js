const express = require('express');
const router = express.Router();
const hooksLoader = require('../lib/hooks-loader');
const libsLoader = require('../lib/libraries-loader');
const path = require('path');

router.post('/_reload', _reload);

function _reload(req, res, next) {
  hooksLoader.load(path.resolve(__dirname, '..', 'config', 'hooks'));
  libsLoader.load(path.resolve(__dirname, '..', 'config', 'libraries'));
  res.sendStatus(200);
}

module.exports = router;