"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const trackController_1 = require("../controllers/trackController");
const router = (0, express_1.Router)();
router.post('/', trackController_1.trackProduct);
exports.default = router;
