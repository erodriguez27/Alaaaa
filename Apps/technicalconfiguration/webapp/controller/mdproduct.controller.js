sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/m/Dialog",
    "sap/m/Text",
    "sap/m/Button"
], function(BaseController, JSONModel, Filter, Dialog, Text, Button) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.mdproduct", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function() {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("mdproduct").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("mdproduct_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("mdproduct_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function(oEvent) {
            /**
             * @type {JSONModel} util         Referencia al modelo "util"
             * @type {JSONModel} OS            Referencia al modelo "OS"
             * @type {JSONModel} DRIVER        Referencia al modelo "MDPRODUCT"
             */

            var util = this.getView().getModel("util"),
                mdproduct = this.getView().getModel("MDPRODUCT");

            //dependiendo del dispositivo, establece la propiedad "phone"
            this.getView().getModel("util").setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            //establece DRIVER como la entidad seleccionada
            util.setProperty("/selectedEntity/", "mdproduct");

            //obtiene los registros de MDPRODUCT
            this.onRead(util, mdproduct);
        },

        /**
         * Obtiene todos los registros de MDPRODUCT
         * @param  {JSONModel} util         Referencia al modelo "util"
         * @param  {JSONModel} mdproduct Referencia al modelo "MDPRODUCT"
         */
        onRead: function(util, mdproduct) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var serviceUrl= util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl+"/product",
                method: "GET",
                success: function(res) {
                    util.setProperty("/busy/", false);
                    mdproduct.setProperty("/records/", res.data);
                },
                error: function(err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };
            util.setProperty("/busy/", true);
            //borra los registros OSPARTNERSHIP que estén almacenados actualmente
            mdproduct.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
        },

        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: function(oEvent) {
            this._resetRecordValues();
            this._editRecordValues(true, "onCreate");
            this._editRecordRequired(true);
            this.onStageLoad("/stage/");
            this.onBreedLoad("/breed/");
        },

        /**
         * carga todas las etapas
         * @param {string} serverName ruta
         */
        onStageLoad: function (serverName) {
            let mdproduct = this.getView().getModel("MDPRODUCT");

            mdproduct.setProperty("/stage/records", []);

            let isRecords = new Promise((resolve, reject) => {
                fetch(serverName).then(
                    function (response) {
                        if (response.status !== 200) {
                            console.log("Looks like there was a problem. status code: " + response.status);
                            return;
                        }
                        response.json().then(function (data) {
                            resolve(data);
                        });
                    }
                ).catch(function (err) {
                    console.error("Fetch error:", err);
                });
            });

            isRecords.then((res) => {

                if (res.data.length > 0) {
                    mdproduct.setProperty("/stage/records", res.data);
                }
            });
        },

        /**
         * carga todas las razas
         * @param {string} serverName ruta
         */
        onBreedLoad: function (serverName) {
            let mdproduct = this.getView().getModel("MDPRODUCT");

            mdproduct.setProperty("/breed/records", []);

            let isRecords = new Promise((resolve, reject) => {
                fetch(serverName).then(
                    function (response) {
                        if (response.status !== 200) {
                            console.log("Looks like there was a problem. status code: " + response.status);
                            return;
                        }
                        response.json().then(function (data) {
                            resolve(data);
                        });
                    }
                ).catch(function (err) {
                    console.error("Fetch error:", err);
                });
            });

            isRecords.then((res) => {

                if (res.data.length > 0) {
                    mdproduct.setProperty("/breed/records", res.data);
                }
            });
        },

        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function() {
            /**
             * @type {JSONModel} MDPRODUCT Referencia al modelo "MDPRODUCT"
             */
            var mdproduct = this.getView().getModel("MDPRODUCT");

            mdproduct.setProperty("/_ID/value", "");
            
            mdproduct.setProperty("/name/value", "");
            mdproduct.setProperty("/name/state", "None");
            mdproduct.setProperty("/name/stateText", "");

            mdproduct.setProperty("/code/value", "");
            mdproduct.setProperty("/code/state", "None");
            mdproduct.setProperty("/code/stateText", "");
            
            mdproduct.setProperty("/breed/selectedKey", "");
            mdproduct.setProperty("/breed/state", "None");
            mdproduct.setProperty("/breed/stateText", "");
            
            mdproduct.setProperty("/stage/selectedKey", "");
            mdproduct.setProperty("/stage/state", "None");
            mdproduct.setProperty("/stage/stateText", "");

            mdproduct.setProperty("/name/ok", false);
            mdproduct.setProperty("/code/ok", false);
        },

        /**
         * Habilita/deshabilita la edición de los datos de un registro MDPRODUCT
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function (edit, f) {
            let mdproduct = this.getView().getModel("MDPRODUCT");
            if (f === "cancelEdit") {
                mdproduct.setProperty("/name/value", mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/name"));
                mdproduct.setProperty("/code/value", mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/code"));
                mdproduct.setProperty("/stage/selectedKey", mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/stage_id") !==null ? mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/stage_id"):"");
                mdproduct.setProperty("/breed/selectedKey", mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/breed_id") !==null ? mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/")+"/breed_id"):"");
                mdproduct.setProperty("/breed/editable", edit);
            } else if (f === "onCreate") {
                mdproduct.setProperty("/breed/editable", edit);
                mdproduct.setProperty("/name/editable", edit);
                mdproduct.setProperty("/code/editable", edit);
            }else{
                mdproduct.setProperty("/name/editable", edit);
                mdproduct.setProperty("/code/editable", edit);
                mdproduct.setProperty("/stage/editable", edit);
                mdproduct.setProperty("/breed/editable", edit);
            }
        },

        /**
         * Se define un campo como obligatorio o no, de un registro MDPRODUCT
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function(edit) {
            var mdproduct = this.getView().getModel("MDPRODUCT");
            mdproduct.setProperty("/name/required", edit);
            mdproduct.setProperty("/code/required", edit);
            mdproduct.setProperty("/breed/required", edit);
            mdproduct.setProperty("/stage/required", edit);
        },

        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function (oEvent) {
            this.getView().byId("productSearchField").setValue("");
            this.onProductSearch();
            this.getRouter().navTo("mdproduct_Create", {}, false /*create history*/ );
        },

        /**
         * Cancela la creación de un registro MDPRODUCT, y regresa a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelCreate: function(oEvent) {
            this._resetRecordValues();
            this.onNavBack(oEvent);
        },

        /**
         * Regresa a la vista principal de la entidad seleccionada actualmente
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNavBack: function(oEvent) {
            /** @type {JSONModel} OS Referencia al modelo "OS" */
            var util = this.getView().getModel("util");

            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/ );
        },

        /**
         * Solicita al servicio correspondiente crear un registro DRIVER
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function(oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                /**
                 * @type {JSONModel} MDPRODUCT   Referencia al modelo "MDPRODUCT"
                 * @type {JSONModel} util    Referencia al modelo "util"
                 * @type {Controller} that    Referencia a este controlador
                 * @type {Object} json        Objeto a enviar en la solicitud
                 * @type {Object} settings    Opciones de la llamada a la función ajax
                 */
                var that = this;
                var util = this.getView().getModel("util");
                var mdproduct = this.getView().getModel("MDPRODUCT");
                var serviceUrl= util.getProperty("/serviceUrl");

                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "name": mdproduct.getProperty("/name/value"),
                        "code": mdproduct.getProperty("/code/value"),
                        "breed" : mdproduct.getProperty("/breed/selectedKey"),
                        "stage" : mdproduct.getProperty("/stage/selectedKey")
                    }),
                    url: serviceUrl+"/product/",
                    dataType: "json",
                    async: true,
                    success: function(data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("mdproduct", {}, true /*no history*/ );
                    },
                    error: function(error) {
                        that.onToast("Error: " + error.responseText);
                    }
                });
            }
        },

        /**
         * Valida la correctitud de los datos existentes en el formulario del registro
         * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
         */
        _validRecord: function() {
            /**
             * @type {JSONModel} MDPRODUCT Referencia al modelo "MDPRODUCT"
             * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
             */
            var mdproduct = this.getView().getModel("MDPRODUCT"),
                flag = true,
                eDriver = false,
                that = this,
                Without_SoL = /^\d+$/,
                Without_Num = /^[a-zA-Z\s]*$/;

            if (mdproduct.getProperty("/name/value") === "") {
                flag = false;
                mdproduct.setProperty("/name/state", "Error");
                mdproduct.setProperty("/name/stateText", "el campo nombre no puede estar vacío");
            } else {
                mdproduct.setProperty("/name/state", "None");
                mdproduct.setProperty("/name/stateText", "");
            }

            if (mdproduct.getProperty("/code/value") === "") {
                flag = false;
                mdproduct.setProperty("/code/state", "Error");
                mdproduct.setProperty("/code/stateText", "el campo código no puede estar vacío");
            } else {
                mdproduct.setProperty("/code/state", "None");
                mdproduct.setProperty("/code/stateText", "");
            }

            if (mdproduct.getProperty("/breed/selectedKey") === "") {
                flag = false;
                mdproduct.setProperty("/breed/state", "Error");
                mdproduct.setProperty("/breed/stateText", "Seleccione una raza");
            }else {
                mdproduct.setProperty("/breed/state", "None");
                mdproduct.setProperty("/breed/stateText", "");
            }
            
            if (mdproduct.getProperty("/stage/selectedKey") === "") {
                flag = false;
                mdproduct.setProperty("/stage/state", "Error");
                mdproduct.setProperty("/stage/stateText", "Seleccione una etapa");
            }else {
                mdproduct.setProperty("/stage/state", "None");
                mdproduct.setProperty("/stage/stateText", "");
            }

            return flag;
        },

        /**
         * Visualiza los detalles de un registro MDPRODUCT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onViewProductRecord: function (oEvent) {
            this.getView().byId("productSearchField").setValue("");
            this.onProductSearch();
            this._resetRecordValues();
            let mdproduct = this.getView().getModel("MDPRODUCT");
            mdproduct.setProperty("/save/", false);
            mdproduct.setProperty("/cancel/", false);
            mdproduct.setProperty("/selectedRecordPath/", oEvent.getSource().getBindingContext("MDPRODUCT"));
            mdproduct.setProperty("/_ID/value", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().product_id);
            mdproduct.setProperty("/product_id/value", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().product_id);
            mdproduct.setProperty("/name/value", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().name);
            mdproduct.setProperty("/name/excepcion", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().name);
            mdproduct.setProperty("/code/value", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().code);
            mdproduct.setProperty("/code/excepcion", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().code);
            mdproduct.setProperty("/breed/selectedKey", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().breed_id !==null ? oEvent.getSource().getBindingContext("MDPRODUCT").getObject().breed_id:"");
            mdproduct.setProperty("/stage/selectedKey", oEvent.getSource().getBindingContext("MDPRODUCT").getObject().stage_id !==null ? oEvent.getSource().getBindingContext("MDPRODUCT").getObject().stage_id:"");
            this.getRouter().navTo("mdproduct_Record", {}, false /*create history*/ );

            mdproduct.setProperty("/name/ok", true);
            mdproduct.setProperty("/code/ok", true);
        },

        /**
         * Coincidencia de ruta para acceder a los detalles de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRecordMatched: function (oEvent) {
            this._viewOptions();
            this.onStageLoad("/stage/");
            this.onBreedLoad("/breed/");
        },

        /**
         * Cambia las opciones de visualización disponibles en la vista de detalles de un registro
         */
        _viewOptions: function(f) {
            var mdproduct = this.getView().getModel("MDPRODUCT");
            mdproduct.setProperty("/cancel/", false);
            mdproduct.setProperty("/modify/", true);
            mdproduct.setProperty("/delete/", true);
            mdproduct.setProperty("/save/", false);

            this._editRecordValues(false, f);
            this._editRecordRequired(false);
        },

        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function(oEvent) {
            var mdproduct = this.getView().getModel("MDPRODUCT");
            mdproduct.setProperty("/name/state", "None");
            mdproduct.setProperty("/name/stateText", "");
            mdproduct.setProperty("/code/state", "None");
            mdproduct.setProperty("/code/stateText", "");
            mdproduct.setProperty("/breed/state", "None");
            mdproduct.setProperty("/breed/stateText", "");
            mdproduct.setProperty("/save/", true);
            mdproduct.setProperty("/cancel/", true);
            mdproduct.setProperty("/modify/", false);
            mdproduct.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues(true);
        },

        /**
         * Cancela la edición de un registro MDPRODUCT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function (oEvent) {
            /** @type {JSONModel} MDPRODUCT  Referencia al modelo MDPRODUCT */

            this.onView("cancelEdit");
        },

        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function (f) {
            this._viewOptions(f);
        },

        /**
         * Solicita al servicio correspondiente actualizar un registro MDPRODUCT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function(oEvent) {
            /**
             * Si el registro que se quiere actualizar es válido y hubo algún cambio
             * con respecto a sus datos originales
             */
            if (this._validRecord() && this._recordChanged()) {
                /**
                 * @type {JSONModel} MDPRODUCT       Referencia al modelo "MDPRODUCT"
                 * @type {JSONModel} util         Referencia al modelo "util"
                 * @type {Controller} that         Referencia a este controlador
                 */
                var mdproduct = this.getView().getModel("MDPRODUCT");
                //var mdbreed = this.getView().getModel("MDBREED");
                var util = this.getView().getModel("util");
                var that = this;
                var serviceUrl= util.getProperty("/serviceUrl");

                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "product_id": mdproduct.getProperty("/_ID/value"),
                        "name": mdproduct.getProperty("/name/value"),
                        "code": mdproduct.getProperty("/code/value"),
                        "breed" : mdproduct.getProperty("/breed/selectedKey"),
                        "stage" : mdproduct.getProperty("/stage/selectedKey")
                    }),
                    url: serviceUrl+"/product/",
                    dataType: "json",
                    async: true,
                    success: function(data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("mdproduct", {}, true /*no history*/ );
                    },
                    error: function(request, status, error) {
                        that.onToast("Error de comunicación");
                        console.log("Read failed");
                    }
                });
            }
        },

        /**
         * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
         * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
         */
        _recordChanged: function() {
            /**
             * @type {JSONModel} MDPRODUCT         Referencia al modelo "MDPRODUCT"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var mdproduct = this.getView().getModel("MDPRODUCT"),
                flag = false;

            if (mdproduct.getProperty("/name/value") !== mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (mdproduct.getProperty("/code/value") !== mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/") + "/code")) {
                flag = true;
            }

            if (mdproduct.getProperty("/breed/selectedKey") != mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/") + "/breed_id")) {
                flag = true;
            }

            if (mdproduct.getProperty("/stage/selectedKey") != mdproduct.getProperty(mdproduct.getProperty("/selectedRecordPath/") + "/stage_id")) {
                flag = true;
            }

            if(!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onProductSearch: function (oEvent) {
            /**
             * Filtra por nombre y codigo 
             * @param {Event} oEvent       Evento que llamó esta función
             * @type {Array}  oFilter      Variable para guardar el resultado de la busqueda
             * @returns {Array} Se envia a la vista el resultado obtenido. 
             */

            var sQuery = this.getView().byId("productSearchField").getValue().toString(),
                binding = this.getView().byId("productTable").getBinding("items");

            if(sQuery){
                let name = new Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                    code = new Filter("code", sap.ui.model.FilterOperator.Contains, sQuery);
                    
                var oFilter = new sap.ui.model.Filter({aFilters:[name, code], and:false});
            }

            //se actualiza el binding de la lista
            binding.filter(oFilter);
        },

        /**
         * Verifica si el producto está en uso en otra entidad
         * @param {JSON} product_id
         */
        onVerifyIsUsed: async function(product_id){
            let ret;
        
            const response = await fetch("/product/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    product_id: product_id
                })
            });
        
            if (response.status !== 200 && response.status !== 409) {
                console.log("Looks like there was a problem. status code: " + response.status);
                return;
            }

            if (response.status === 200) {
                const res = await response.json();
                ret = res.data.used;
            }

            return ret;
        },

        /**
         * Levanta el Diálogo que muestra la confirmación del Eliminar un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function(oEvent) {
            let oBundle = this.getView().getModel("i18n").getResourceBundle(),
                confirmation = oBundle.getText("confirmation"),
                util = this.getView().getModel("util"),
                mdproduct = this.getView().getModel("MDPRODUCT"),
                product_id = mdproduct.getProperty("/product_id/value"),
                that = this;

            let cond = await this.onVerifyIsUsed(product_id);
            console.log("La condición:", cond);
            if (cond) {
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new Text({
                        text: "No se puede eliminar el Producto, porque está siendo utilizado."
                    }),
                    beginButton: new Button({
                        text: "OK",
                        press: function() {
                            dialog.close();
                        }
                    }),
                    afterClose: function() {
                        dialog.destroy();
                    }
                });
        
                dialog.open();
            } else {
                var dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Desea eliminar este producto?"
                    }),
                    beginButton: new Button({
                        text: "Si",
                        press: function() {
                            util.setProperty("/busy/", true);
                            console.log(util);
                                
                            var serviceUrl= util.getProperty("/serviceUrl");
                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "product_id": product_id
                                }),
                                url: serviceUrl+"/product/",
                                dataType: "json",
                                async: true,
                                success: function(data) {
                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("mdproduct", {}, true);
                                    dialog.close();
                                    dialog.destroy();
                                },
                                error: function(request, status, error) {
                                    that.onToast("Error de comunicación");
                                    console.log("Read failed");
                                }
                            });
                        }
                    }),
                    endButton: new Button({
                        text: "No",
                        press: function() {
                            dialog.close();
                            dialog.destroy();
                        }
                    })
                });

                dialog.open();
            }  
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: function(oEvent){
            let input= oEvent.getSource();
            let nwName = input.getValue();
            //input.setValue(input.getValue().trim());
            let mdModel= this.getModel("MDPRODUCT");
            let excepcion= mdModel.getProperty("/name/excepcion");

            if (nwName.length > 45) {
                mdModel.setProperty("/name/state", "Error");
                mdModel.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                mdModel.setProperty("/name/ok", false);
            } else {
                this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeCode: function(oEvent){
            let input= oEvent.getSource();
            let nwCode = input.getValue().trim();
            input.setValue(input.getValue().trim());
            let mdModel= this.getModel("MDPRODUCT");
            let excepcion= mdModel.getProperty("/code/excepcion");

            if (nwCode.length > 20) {
                mdModel.setProperty("/code/state", "Error");
                mdModel.setProperty("/code/stateText", "Excede el limite de caracteres permitido (20)");
                mdModel.setProperty("/code/ok", false);
            } else {
                this.checkChange(input.getValue().toString(), excepcion.toString(), "/code", "changeCode");
            }
        },
        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de etapa en el formulario.
         * @param {Event} oEvent Evento que llamó esta función
         */
        onStage: function (oEvent) {
            let mdproduct = this.getView().getModel("MDPRODUCT");
            let selectedKey = oEvent.getParameters().selectedItem.mProperties.key;
            let selectedText = this.getView().byId("product_stage_select").getSelectedItem().mProperties.text;
            let sServerName = (selectedText === "Cría y Levante") || selectedText === "Reproductoras" ? "/breed/findAllBreedWP": "/breed/";

            mdproduct.setProperty("/stage/selectedKey", selectedKey);
            this.onBreedLoad(sServerName);
            mdproduct.setProperty("/breed/selectedKey", "");
            mdproduct.setProperty("/breed/editable", true);

            mdproduct.setProperty("/stage/state", "None");
            mdproduct.setProperty("/stage/stateText", "");
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de etapa en el formulario.
         * @param {Event} oEvent Evento que llamó esta función
         */
        onBreed: function (oEvent) {
            let mdproduct = this.getView().getModel("MDPRODUCT");
            let selectedKey = oEvent.getParameters().selectedItem.mProperties.key;
            mdproduct.setProperty("/breed/selectedKey", selectedKey);
            mdproduct.setProperty("/breed/state", "None");
            mdproduct.setProperty("/breed/stateText", "");
        },

        /**
         * Valida si el registro de entrada es único 
         * @param {String} name valor de entrada
         * @param {String} excepcion excepcion del modelo 
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct función a validar
         */
        checkChange: async function(name, excepcion,field, funct){
            let mdModel= this.getModel("MDPRODUCT");

            if (name=="" || name===null) {
                mdModel.setProperty(field+"/state", "None");
                mdModel.setProperty(field+"/stateText", "");
                mdModel.setProperty(field+"/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found;

                if (funct === "changeCode") {
                    found = await registers.find(element => ((element.code).toLowerCase() === name.toLowerCase() && element.code != excepcion));
                } else {
                    found = await registers.find(element => ((element.name).toLowerCase() === name.toLowerCase() && element.name !== excepcion));
                }

                if (found === undefined) {
                    mdModel.setProperty(field+"/state", "Success");
                    mdModel.setProperty(field+"/stateText", "");
                    mdModel.setProperty(field+"/ok", true);
                } else {
                    mdModel.setProperty(field+"/state", "Error");
                    mdModel.setProperty(field+"/stateText", (funct==="changeCode") ? "código ya existente" : "nombre ya existente");
                    mdModel.setProperty(field+"/ok", false);
                }
            }
        }
    });
});