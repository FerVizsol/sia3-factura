const controller = {};
// facturas,vendedor, puntoventa, cliente, empresa, productos
//route to crear factura
controller.agregarfac = (req, res) => {
    let dataPuntoVentas;
    let dataProductos;
    let dataVendedores;
    let dataClientes;
    let dataEmpresa;
    req.getConnection((err, conn) => {
        if (err) {
            res.json(err);
            return;
        }

        conn.query("SELECT * from vendedor", (err, vendedores) => {
            if (err) {
                res.json(err);
                return;
            }
            dataVendedores = vendedores;

            conn.query("SELECT * from puntoventa", (err, puntoventa) => {
                if (err) {
                    res.json(err);
                    return;
                }
                dataPuntoVentas = puntoventa;

                conn.query("SELECT * from producto", (err, producto) => {
                    if (err) {
                        res.json(err);
                        return;
                    }
                    dataProductos = producto;

                    conn.query("SELECT * from cliente", (err, cliente) => {
                        if (err) {
                            res.json(err);
                            return;
                        }
                        dataClientes = cliente;

                        conn.query("SELECT * from empresa", (err, empresa) => {
                            if (err) {
                                res.json(err);
                                return;
                            }
                            dataEmpresa = empresa;

                            res.render('crearfactura', {
                                dataV: dataVendedores,
                                dataPun: dataPuntoVentas,
                                dataP: dataProductos,
                                dataC: dataClientes,
                                dataE: dataEmpresa
                            });
                        });
                    });
                });
            });
        });
    });
}


//selects
controller.listfacturas = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query("SELECT    f.codFactura AS CodigoFactura,    f.fecha_emision AS FechaEmision,    c.codRuc AS NumeroRucCliente,    SUM(df.costoSubTotal + df.costoIGV) AS CostoTotalFactura,    f.codEstado AS EstadoFactura FROM    factura f INNER JOIN    cliente c ON f.codCliente = c.codRuc INNER JOIN     detalle_factura df ON f.codFactura = df.codFactura GROUP BY    f.codFactura,  f.fecha_emision, c.codRuc, f.codEstado;",(err,factura) =>{
            if(err){
                res.json(err);
            }
            console.log(factura);
            res.render('factura',{
                data:factura
            });
        })
    });
}




controller.listvendedor = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query('SELECT * from vendedor',(err,vendedor) =>{
            if(err){
                res.json(err);
            }
            console.log(vendedor);
            res.render('vendedor',{
                data:vendedor
            });
        })
    });
}
controller.listpuntoventa = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query('SELECT * from puntoventa',(err,puntoventa) =>{
            if(err){
                res.json(err);
            }
            console.log(puntoventa);
            res.render('puntoventa',{
                data:puntoventa
            });
        })
    });
}
controller.listcliente = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query('SELECT * from cliente',(err,cliente) =>{
            if(err){
                res.json(err);
            }
            console.log(cliente);
            res.render('cliente',{
                data:cliente
            });
        })
    });
}
controller.listempresa = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query('SELECT * from empresa',(err,empresa) =>{
            if(err){
                res.json(err);
            }
            console.log(empresa);
            res.render('empresa',{
                data:empresa
            });
        })
    });
}
controller.listproductos = (req,res)=> {
    req.getConnection((err,conn) =>{
        conn.query('SELECT * from producto',(err,producto) =>{
            if(err){
                res.json(err);
            }
            console.log(producto);
            res.render('producto',{
                data:producto
            });
        })
    });
}
    controller.cargarClienteFactura = (req,res) =>{
        const selectedOption = req.body.selectedOption;
        console.log(selectedOption);
        res.send(`Selected option: ${selectedOption}`);
    }

    controller.enviarFactura = (req, res) => {
        const { id } = req.params;
        req.getConnection((err, conn) => {
            if (err) {
                return res.status(500).json(err);
            }
    
            // Fetch facturaInfo
            conn.query('SELECT * FROM factura WHERE codFactura = ?', [id], (err, facturaInfo) => {
                if (err) {
                    return res.status(500).json(err);
                }
                if (facturaInfo.length === 0) {
                    return res.status(404).json({ error: 'Factura not found' });
                }
    
                const codRuc = facturaInfo[0].codCliente;
                const codPuntoVenta = facturaInfo[0].codPunto;
                const codEmpresa = facturaInfo[0].codEmpresa;
    
                // Fetch clienteInfo
                conn.query('SELECT * FROM cliente WHERE codRuc = ?', [codRuc], (err, clienteInfo) => {
                    if (err) {
                        return res.status(500).json(err);
                    }
    
                    // Fetch puntoVentaInfo
                    conn.query('SELECT * FROM puntoventa WHERE codPunto = ?', [codPuntoVenta], (err, puntoVentaInfo) => {
                        if (err) {
                            return res.status(500).json(err);
                        }
    
                        // Fetch cuerpoInfo
                        conn.query(
                            `SELECT
                                p.nombre AS nombre_producto,
                                df.cantidadComprada,
                                p.costoUnitario,
                                (df.cantidadComprada * p.costoUnitario) AS total
                            FROM
                                detalle_factura df
                            INNER JOIN
                                producto p ON df.codProducto = p.codProducto
                            WHERE
                                df.codFactura = ?`,
                            [id],
                            (err, cuerpoInfo) => {
                                if (err) {
                                    return res.status(500).json(err);
                                }
    
                                // Fetch totalInfo
                                conn.query(
                                    `SELECT
                                        CASE
                                            WHEN p.afectaIgv = 1 THEN
                                                (df.cantidadComprada * p.costoUnitario)
                                            ELSE
                                                0
                                        END AS opAgravadas,
                                        CASE
                                            WHEN p.afectaIgv = 1 THEN
                                                ((df.cantidadComprada * p.costoUnitario) * it.igvDecimal)
                                            ELSE
                                                0
                                        END AS IGV,
                                        CASE
                                            WHEN p.afectaIgv = 0 THEN
                                                (df.cantidadComprada * p.costoUnitario)
                                            ELSE
                                                0
                                        END AS opExonerado
                                    FROM
                                        detalle_factura df
                                    INNER JOIN
                                        producto p ON df.codProducto = p.codProducto
                                    INNER JOIN
                                        igvTipos it ON p.tipoIgv = it.codIgv
                                    WHERE
                                        df.codFactura = ?`,
                                    [id],
                                    (err, totalInfo) => {
                                        if (err) {
                                            return res.status(500).json(err);
                                        }
                                        console.log(facturaInfo);
                                        console.log(clienteInfo);
                                        console.log(puntoVentaInfo);
                                        console.log(cuerpoInfo);
                                        console.log(totalInfo);
                                        // Render the view with all the fetched data
                                        res.render('ENVIARFACTURA', {
                                            facturaInfo,
                                            clienteInfo,
                                            puntoVentaInfo,
                                            cuerpoInfo,
                                            totalInfo,
                                        });
                                    }
                                );
                            }
                        );
                    });
                });
            });
        });
    };
    
// inserts

// deletes

// updates


module.exports = controller;