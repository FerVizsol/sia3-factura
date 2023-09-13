const express = require('express');
const router = express.Router();
const customerControllers = require('../controllers/customerControllers');
const controller = require('../controllers/customerControllers');


router.get('/', customerControllers.listfacturas);
router.get('/vendedor', customerControllers.listvendedor);
router.get('/puntoventa', customerControllers.listpuntoventa);
router.get('/cliente', customerControllers.listcliente);
router.get('/empresa', customerControllers.listempresa);
router.get('/productos', customerControllers.listproductos);
router.get('/crearfactura',customerControllers.agregarfac);
router.post('/cargarClienteFactura',customerControllers.cargarClienteFactura)
router.get('/ENVIARFACTURA/:id',customerControllers.enviarFactura)

module.exports = router;