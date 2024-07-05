"use strict";
var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _Server_instances, _Server_engine, _Server_registerMiddlwares, _Server_registerHandlers;
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const env_1 = __importDefault(require("../env"));
class Server {
    constructor() {
        _Server_instances.add(this);
        _Server_engine.set(this, void 0);
        __classPrivateFieldSet(this, _Server_engine, (0, express_1.default)(), "f");
    }
    start() {
        __classPrivateFieldGet(this, _Server_instances, "m", _Server_registerMiddlwares).call(this);
        __classPrivateFieldGet(this, _Server_instances, "m", _Server_registerHandlers).call(this);
        __classPrivateFieldGet(this, _Server_engine, "f").listen(parseInt((0, env_1.default)('PORT')), () => {
            console.log(`\nServer listening on ${(0, env_1.default)("PORT")}`);
        });
    }
}
_Server_engine = new WeakMap(), _Server_instances = new WeakSet(), _Server_registerMiddlwares = function _Server_registerMiddlwares() {
    __classPrivateFieldGet(this, _Server_engine, "f").use(express_1.default.json());
    __classPrivateFieldGet(this, _Server_engine, "f").use((0, cors_1.default)());
}, _Server_registerHandlers = function _Server_registerHandlers() { };
exports.default = Server;
