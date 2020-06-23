sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/m/Dialog",
    "sap/m/Text",
    "sap/m/Button"
], function (BaseController, JSONModel, Filter, Dialog, Text, Button) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.mdbroilerProduct", {
    
        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function () {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("mdbroilerProduct").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("mdbroilerProduct_Record").attachPatternMatched(this._onRecordMatched, this);
            
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("mdbroilerProduct_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function (oEvent) {
            /**
             * @type {Controller} that         Referencia a este controlador
             * @type {JSONModel} util         Referencia al modelo "util"
             * @type {JSONModel} OS            Referencia al modelo "OS"
             * @type {JSONModel} MDSTAGE        Referencia al modelo "MdSTAGE"
             */

            let that = this;
            let util = this.getView().getModel("util");
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            
            //dependiendo del dispositivo, establece la propiedad "phone"
            this.getView().getModel("util").setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            //establece MDSTAGE como la entidad seleccionada
            util.setProperty("/selectedEntity/", "mdbroilerProduct");

            //obtiene los registros de mdbroilerProduct
            this.onBreedLoad();
            this.onRead(that, util, mdbroilerProduct);
        },
        /**
         *
         * Obtiene los registros de Raza "MDBREED"
         */
        onBreedLoad: function () {
            const serverName = "/breed";
            let mdbreed = this.getView().getModel("MDBREED");

            mdbreed.setProperty("/records", []);

            let isRecords = new Promise((resolve, reject) => {
                fetch(serverName).then(
                    function (response) {
                        if (response.status !== 200) {
                            console.log("Looks like there was a problem. status code: " + response.status);
                            return;
                        }
                        // Examine the text in the response
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
                    mdbreed.setProperty("/records", res.data);
                }
            });
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de raza en el formulario.
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onBreed: function (oEvent) {
            var campo = oEvent.getParameters().selectedItem.mProperties.key;
            var mdbreed = this.getView().getModel("MDBREED");
            var mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");

            mdbreed.setProperty("/selectedKey", campo);
            mdbroilerProduct.setProperty("/breed/state", "None");
            mdbroilerProduct.setProperty("/breed/stateText", "");

            mdbroilerProduct.setProperty("/gender/enabled", true);
            mdbroilerProduct.setProperty("/gender/selectedKey", "");

        },

         /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de sexo en el formulario.
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onGenderChange: function (oEvent) {
            let gender = this.getView().byId("genderSelect").getSelectedKey();
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            mdbroilerProduct.setProperty("/gender/state", "None");
            mdbroilerProduct.setProperty("/gender/stateText", "");
        },

        /**
         * Obtiene todos los registros de MDBROILERPRODUCT
         * @param  {Controller} that         Referencia al controlador que llama esta función
         * @param  {JSONModel} util         Referencia al modelo "util"
         * @param  {JSONModel} MDBROILERPRODUCT Referencia al modelo "MDBROILERPRODUCT"
         */
        onRead: function (that, util, mdbroilerProduct) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var service = util.getProperty("/serviceUrl");
            var settings = {
                url: service + "/broiler_product",
                method: "GET",
                success: function (res) {

                    util.setProperty("/busy/", false);
                    mdbroilerProduct.setProperty("/records/", res.data);
                },
                error: function (err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                    //that.onConnectionError();
                }
            };
            util.setProperty("/busy/", true);
            mdbroilerProduct.setProperty("/records/", []);
            $.ajax(settings);
        },

        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function (oEvent) {
            this.getView().byId("broilerProductSearchField").setValue("");
            this.onbroilerProductSearch();
            this.getRouter().navTo("mdbroilerProduct_Create", {}, false /*create history*/);
        },

        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: function (oEvent) {
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            this._resetRecordValues();
            this.onBreedLoad();
            this._editRecordRequired(true);
            mdbroilerProduct.setProperty("/code/editable", true);
        },

        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function () {
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            let mdbreed = this.getView().getModel("MDBREED");

            mdbroilerProduct.setProperty("/name/editable", true);
            mdbroilerProduct.setProperty("/name/value", "");
            mdbroilerProduct.setProperty("/name/state", "None");
            mdbroilerProduct.setProperty("/name/stateText", "");

            mdbroilerProduct.setProperty("/weight/editable", true);
            mdbroilerProduct.setProperty("/weight/value", "");
            mdbroilerProduct.setProperty("/weight/state", "None");
            mdbroilerProduct.setProperty("/weight/stateText", "");

            mdbroilerProduct.setProperty("/days_eviction/editable", true);
            mdbroilerProduct.setProperty("/days_eviction/value", "");
            mdbroilerProduct.setProperty("/days_eviction/state", "None");
            mdbroilerProduct.setProperty("/days_eviction/stateText", "");

            mdbroilerProduct.setProperty("/min_days/editable", true);
            mdbroilerProduct.setProperty("/min_days/value", "");
            mdbroilerProduct.setProperty("/min_days/state", "None");
            mdbroilerProduct.setProperty("/min_days/stateText", "");

            mdbroilerProduct.setProperty("/gender/enabled", true);
            mdbroilerProduct.setProperty("/gender/selectedKey", "");
            mdbroilerProduct.setProperty("/gender/state", "None");
            mdbroilerProduct.setProperty("/gender/stateText", "");

            mdbroilerProduct.setProperty("/breed/enabled", true);
            mdbreed.setProperty("/selectedKey", "");
            mdbroilerProduct.setProperty("/breed/state", "None");
            mdbroilerProduct.setProperty("/breed/stateText", "");
            
            mdbroilerProduct.setProperty("/code/editable", false);
            mdbroilerProduct.setProperty("/code/value", "");
            mdbroilerProduct.setProperty("/code/state", "None");
            mdbroilerProduct.setProperty("/code/stateText", "");
        },

        /**
         * Habilita/deshabilita la edición de los datos de un registro MDBROILERPRODUCT
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function (edit, code = false) {
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");

            mdbroilerProduct.setProperty("/name/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/name"));
            mdbroilerProduct.setProperty("/gender/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/gender"));
            mdbroilerProduct.setProperty("/weight/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/weight"));
            mdbroilerProduct.setProperty("/days_eviction/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/days_eviction"));
            mdbroilerProduct.setProperty("/min_days/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/min_days_eviction"));
            mdbroilerProduct.setProperty("/code/value", mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/")+"/code"));

            mdbroilerProduct.setProperty("/breed/enabled", edit);
            mdbroilerProduct.setProperty("/name/editable", edit);
            mdbroilerProduct.setProperty("/gender/enabled", edit);
            mdbroilerProduct.setProperty("/weight/editable", edit);
            mdbroilerProduct.setProperty("/days_eviction/editable", edit);
            mdbroilerProduct.setProperty("/min_days/editable", edit);
            mdbroilerProduct.setProperty("/code/editable", code);
        },

        /**
         * Se define un campo como obligatorio o no, de un registro MDBROILERPRODUCT
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function (edit) {
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");

            mdbroilerProduct.setProperty("/breedRequired", edit);
            mdbroilerProduct.setProperty("/name/required", edit);
            mdbroilerProduct.setProperty("/gender/required", edit);
            mdbroilerProduct.setProperty("/weight/required", edit);
            mdbroilerProduct.setProperty("/days_eviction/required", edit);
            mdbroilerProduct.setProperty("/min_days/required", edit);
            mdbroilerProduct.setProperty("/code/required", edit);
        },

        /**
         * Solicita al servicio correspondiente crear un registro MDBROILERPRODUCT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function (oEvent) {
            //Si el registro que se desea crear es válido

            if (this._validRecord()) {

                let that = this;
                let util = this.getView().getModel("util");
                let serviceUrl = util.getProperty("/serviceUrl");
                let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
                let mdbreed = this.getView().getModel("MDBREED");

                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "name": mdbroilerProduct.getProperty("/name/value"),
                        "weight": mdbroilerProduct.getProperty("/weight/value"),
                        "days_eviction": mdbroilerProduct.getProperty("/days_eviction/value"),
                        "min_days": mdbroilerProduct.getProperty("/min_days/value"),
                        "code": mdbroilerProduct.getProperty("/code/value"),
                        "gender": mdbroilerProduct.getProperty("/gender/selectedKey"),
                        "breed_id": mdbreed.getProperty("/selectedKey")
                    }),
                    url: serviceUrl + "/broiler_product",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("mdbroilerProduct", {}, true /*no history*/);

                    },
                    error: function (request) {
                        var msg = request.statusText;
                        that.onToast("Error:" + msg);
                    }
                });
            }
        },
        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato decimal
         * @param {*} o numero
         */
        validateFloatInput: function (o) {
            let input = o.getSource();
            let floatLength = 2,
                intLength = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^([0-9]{1,${intLength}})([.][0-9]{0,${floatLength}})?$/`);


            if (regex.test(value)) {
                input.setValueState("None");
                input.setValueStateText("");
                return true;
            } else {
                let pNumber = 0;
                let aux = value.split("").filter(char => {
                    if (/^[0-9.]$/.test(char)) {
                        if (char !== ".") {
                            return true;
                        }
                        else {
                            if (pNumber === 0) {
                                pNumber++;
                                return true;
                            }
                        }
                    }
                }).join("").split(".");

                value = aux[0].substring(0, intLength);

                if (aux[1] !== undefined) {
                    value += "." + aux[1].substring(0, floatLength);
                }

                if (value > 0) {
                    input.setValue(value);
                } else {
                    input.setValue("");
                }

                let origin = input.sId.split("--")[1];
                
                this.detectFailure_C_W(origin, value)

                return false;
            }
        },

        /**
        * Valida la correctitud de los datos existentes en el formulario del registro
        * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
        */
        _validRecord: function () {
            /**
            * @type {JSONModel} MDBROILERPRODUCT Referencia al modelo "MDBROILERPRODUCT"
            * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
            */
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            let mdbreed = this.getView().getModel("MDBREED");
            let flag = true;
            let Without_SoL = /^\d+$/;
            let Without_Num = /^[a-zA-Z\s]*$/;
            let days_eviction_value = parseInt(mdbroilerProduct.getProperty("/days_eviction/value"));
            let min_days_value = parseInt(mdbroilerProduct.getProperty("/min_days/value"));

            mdbroilerProduct.setProperty("/name/state", "None");
            mdbroilerProduct.setProperty("/weight/state", "None");
            mdbroilerProduct.setProperty("/days_eviction/state", "None");
            mdbroilerProduct.setProperty("/min_days/state", "None");
            mdbroilerProduct.setProperty("/code/state", "None");

            mdbroilerProduct.setProperty("/name/stateText", "");
            mdbroilerProduct.setProperty("/weight/stateText", "");
            mdbroilerProduct.setProperty("/days_eviction/stateText", "");
            mdbroilerProduct.setProperty("/min_days/stateText", "");
            mdbroilerProduct.setProperty("/code/stateText", "");

            if (mdbroilerProduct.getProperty("/name/value") === "" || mdbroilerProduct.getProperty("/name/value") === null) {
                flag = false;
                mdbroilerProduct.setProperty("/name/state", "Error");
                mdbroilerProduct.setProperty("/name/stateText", "el campo nombre no puede estar vacío");
            }

            if (mdbroilerProduct.getProperty("/weight/value") === "" || mdbroilerProduct.getProperty("/weight/value") === null || parseInt(mdbroilerProduct.getProperty("/weight/value")) === 0) {
                flag = false;
                mdbroilerProduct.setProperty("/weight/state", "Error");
                mdbroilerProduct.setProperty("/weight/stateText", (mdbroilerProduct.getProperty("/weight/value") === "") ? this.getI18n().getText("enter.FIELD") : this.getI18n().getText("enter.FIELD.greaterThan"));
            }

            if (Number.isNaN(days_eviction_value) || days_eviction_value === null || parseInt(days_eviction_value) === 0) {
                flag = false;
                mdbroilerProduct.setProperty("/days_eviction/state", "Error");
                mdbroilerProduct.setProperty("/days_eviction/stateText", (Number.isNaN(days_eviction_value)) ? this.getI18n().getText("enter.FIELD") : this.getI18n().getText("enter.FIELD.greaterThan"));
            }else if(min_days_value > days_eviction_value){
                flag = false;
                mdbroilerProduct.setProperty("/days_eviction/state", "Error");
                mdbroilerProduct.setProperty("/days_eviction/stateText", "El máximo no puede ser menor al mínimo");
            } 

            if (Number.isNaN(min_days_value) || min_days_value === null || parseInt(min_days_value) === 0 ) {
                flag = false;
                mdbroilerProduct.setProperty("/min_days/state", "Error");
                mdbroilerProduct.setProperty("/min_days/stateText", (Number.isNaN(min_days_value)) ? this.getI18n().getText("enter.FIELD") : this.getI18n().getText("enter.FIELD.greaterThan"));
            }else if(min_days_value > days_eviction_value){
                flag = false;
                mdbroilerProduct.setProperty("/min_days/state", "Error");
                mdbroilerProduct.setProperty("/min_days/stateText", "El mínimo no puede ser mayor al máximo");
            }

            if (mdbroilerProduct.getProperty("/gender/selectedKey") === "" || mdbroilerProduct.getProperty("/gender/selectedKey") === null || parseInt(mdbroilerProduct.getProperty("/gender/value")) === 0) {
                flag = false;
                mdbroilerProduct.setProperty("/gender/state", "Error");
                mdbroilerProduct.setProperty("/gender/stateText", "debe seleccionar el sexo");
            }

            if ((mdbreed.getProperty("/selectedKey")) === "" || mdbreed.getProperty("/selectedKey") === null) {
                flag = false;
                mdbroilerProduct.setProperty("/breed/state", "Error");
                mdbroilerProduct.setProperty("/breed/stateText", "debe seleccionar la raza");
            }

            if (mdbroilerProduct.getProperty("/code/value") === "" || mdbroilerProduct.getProperty("/code/value") === null) {
                flag = false;
                mdbroilerProduct.setProperty("/code/state", "Error");
                mdbroilerProduct.setProperty("/code/stateText", "el campo código no puede estar vacío");
            }           

            return flag;
        },

        /**
         * Visualiza los detalles de un registro MDBROILERPRODUCT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onViewBroilerProductRecord: function(oEvent){
            
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            let mdbreed = this.getView().getModel("MDBREED");
            let oRecord = JSON.parse(JSON.stringify(oEvent.getSource().getBindingContext("MDBROILERPRODUCT").getObject()));

            mdbroilerProduct.setProperty("/selectedRecordPath/", oEvent.getSource().getBindingContext("MDBROILERPRODUCT")["sPath"]);
            mdbroilerProduct.setProperty("/selectedRecord", oRecord);
            mdbreed.setProperty("/selectedKey", oRecord.breed_id);
            mdbroilerProduct.setProperty("/name/value", oRecord.name);
            mdbroilerProduct.setProperty("/gender/selectedKey", oRecord.gender);
            mdbroilerProduct.setProperty("/weight/value", oRecord.weight);
            mdbroilerProduct.setProperty("/days_eviction/value", oRecord.days_eviction);
            mdbroilerProduct.setProperty("/min_days/value", oRecord.min_days_eviction);
            mdbroilerProduct.setProperty("/code/value", oRecord.code);

            this.getRouter().navTo("mdbroilerProduct_Record", {}, true);
            this.getView().byId("broilerProductSearchField").setValue("");
            this.onbroilerProductSearch();
        },

        /**
        * Coincidencia de ruta para acceder a los detalles de un registro
        * @param  {Event} oEvent Evento que llamó esta función
        */
        _onRecordMatched: function (oEvent) {
            this._viewOptions();
        },

        /**
        * Cambia las opciones de visualización disponibles en la vista de detalles de un registro
        */
        _viewOptions: function () {
            var mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            mdbroilerProduct.setProperty("/save/", false);
            mdbroilerProduct.setProperty("/cancel/", false);
            mdbroilerProduct.setProperty("/modify/", true);
            mdbroilerProduct.setProperty("/delete/", true);

            this._editRecordValues(false);
            this._editRecordRequired(false);
        },

        /**
       * Solicita al servicio correspondiente actualizar un registro MDBROILERPRODUCT
       * @param  {Event} oEvent Evento que llamó esta función
       */
        onUpdate: function (oEvent) {
            // Si el registro que se quiere actualizar es válido y hubo algún cambio
            if (this._validRecord() && this._recordChanged()) {
                /**
                * @type {JSONModel} MDBROILERPRODUCT Referencia al modelo "MDBROILERPRODUCT"
                * @type {JSONModel} util Referencia al modelo "util"
                * @type {Controller} that Referencia a este controlador
                */
                var mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
                var util = this.getView().getModel("util");
                var serviceUrl = util.getProperty("/serviceUrl");
                var that = this;
                let mdbreed = this.getView().getModel("MDBREED");

                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "broiler_product_id": mdbroilerProduct.getProperty("/selectedRecord/broiler_product_id/"),
                        "name": mdbroilerProduct.getProperty("/name/value"),
                        "weight": mdbroilerProduct.getProperty("/weight/value"),
                        "days_eviction": mdbroilerProduct.getProperty("/days_eviction/value"),
                        "min_days": mdbroilerProduct.getProperty("/min_days/value"),
                        "code": mdbroilerProduct.getProperty("/code/value"),
                        "gender": mdbroilerProduct.getProperty("/gender/selectedKey"),
                        "breed_id": mdbreed.getProperty("/selectedKey"),
                        
                    }),
                    url: serviceUrl + "/broiler_product",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("mdbroilerProduct", {}, true /*no history*/);
                    },
                    error: function (request) {
                        let msg = request.statusText;

                        that.onToast("Error:" + msg);
                    }
                });
            }
        },

        /**
        * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
        * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
        */
        _recordChanged: function () {
            /**
            * @type {JSONModel} MDBREED         Referencia al modelo "MDSTAGE"
            * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
            */
            var mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT"),
                flag = false,
                mdbreed = this.getView().getModel("MDBREED");

            if (mdbroilerProduct.getProperty("/name/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/name")
                || mdbroilerProduct.getProperty("/days_eviction/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/days_eviction")
                || mdbroilerProduct.getProperty("/min_days/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/min_days")
                || mdbroilerProduct.getProperty("/weight/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/weight")
                || mdbreed.getProperty("/selectedKey") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/breed_id")
                || mdbroilerProduct.getProperty("/code/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/code")
                || mdbroilerProduct.getProperty("/conver/value") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/conver")
                || mdbroilerProduct.getProperty("/gender/selectedKey") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/gender")
                || mdbroilerProduct.getProperty("/type_bird/selectedKey") !== mdbroilerProduct.getProperty(mdbroilerProduct.getProperty("/selectedRecordPath/") + "/type_bird")
            ) {
                flag = true;
            }

            if (!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function (oEvent) {
            var mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            mdbroilerProduct.setProperty("/save/", true);
            mdbroilerProduct.setProperty("/cancel/", true);
            mdbroilerProduct.setProperty("/modify/", false);
            mdbroilerProduct.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues(true);

            mdbroilerProduct.setProperty("/code/editable", true);
            // mdbroilerProduct.setProperty("/breed/enabled", false);
            // mdbroilerProduct.setProperty("/gender/enabled", false);
            // mdbroilerProduct.setProperty("/type_bird/enabled", false);
        },
        
        /**
         * Verifica si el producto de engorde está en uso en otra entidad
         * @param {JSON} broiler_product_id
         */
        onVerifyIsUsed: async function (broiler_product_id) {
            let ret;

            const response = await fetch("/broiler_product/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    broiler_product_id: broiler_product_id
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
         * Levanta el Diálogo que muestra la confirmacion del Eliminar un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function (oEvent) {
            let oBundle = this.getView().getModel("i18n").getResourceBundle(),
                deleteRecord = oBundle.getText("deleteRecord"),
                confirmation = oBundle.getText("confirmation"),
                util = this.getView().getModel("util"),
                serviceUrl = util.getProperty("/serviceUrl"),
                that = this,
                mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT"),
                broiler_product_id = mdbroilerProduct.getProperty("/selectedRecord/broiler_product_id");

            let cond = await this.onVerifyIsUsed(broiler_product_id);

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
                        press: function () {
                            dialog.close();
                        }
                    }),
                    afterClose: function () {
                        dialog.destroy();
                    }
                });

                dialog.open();
            } else {
                let dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Desea eliminar este producto de engorde?"
                    }),
                    beginButton: new Button({
                        text: "Si",
                        press: function () {
                            util.setProperty("/busy/", true);

                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "broiler_product_id": broiler_product_id
                                }),
                                url: serviceUrl + "/broiler_product",
                                dataType: "json",
                                async: true,
                                success: function (data) {
                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("mdbroilerProduct", {}, true);
                                    dialog.close();
                                    dialog.destroy();
                                },
                                error: function (request, status, error) {
                                    that.onToast("Error de comunicación");
                                    console.error("Read failed:", error);
                                }
                            });
                        }
                    }),
                    endButton: new Button({
                        text: "No",
                        press: function () {
                            dialog.close();
                            dialog.destroy();
                        }
                    })
                });

                dialog.open();
            }
        },

        /**
         * Cancela la creación de un registro MDSTAGE, y regresa a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelCreate: function (oEvent) {
            this._resetRecordValues();
            this.onNavBack(oEvent);
        },

        /**
         * Regresa a la vista principal de la entidad seleccionada actualmente
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNavBack: function (oEvent) {
            /** @type {JSONModel} OS Referencia al modelo "OS" */
            this._resetRecordValues();
            var util = this.getView().getModel("util");

            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/);
        },

        /**
         * Cancela la edición de un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function (oEvent) {
            /** @type {JSONModel} MDSTAGE  Referencia al modelo MDSTAGE */
            this.onView();
        },

        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function () {
            this._viewOptions();
        },
        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onbroilerProductSearch: function (oEvent) {
            
            /**
             * Filtra por nombre y codigo 
             * @param {Event} oEvent       Evento que llamó esta función
             * @type {Array}  oFilter      Variable para guardar el resultado de la busqueda
             * @returns {Array} Se envia a la vista el resultado obtenido. 
             */

            let sQuery = this.getView().byId("broilerProductSearchField").getValue().toString(),
                binding = this.getView().byId("broilerProductTable").getBinding("items");

            if(sQuery){
                let name = new Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                    code = new Filter("code", sap.ui.model.FilterOperator.Contains, sQuery);
                    
                var oFilter = new sap.ui.model.Filter({aFilters:[name, code], and:false});
            }

            binding.filter(oFilter);
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: function (oEvent) {
            let input = oEvent.getSource(),
                nwCode = input.getValue()
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");

            if (nwCode.length > 45) {
                mdbroilerProduct.setProperty("/name/state", "Error");
                mdbroilerProduct.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                mdbroilerProduct.setProperty("/name/ok", false);
                mdbroilerProduct.setProperty("/nButton", false);
            } else {
                this.checkChange(input.getValue().toString(), "/name", "changeName");
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeCode: function (oEvent) {
            let input = oEvent.getSource(),
                nwCode = input.getValue().trim();
            input.setValue(input.getValue().trim());
            let mdbroilerProduct = this.getView().getModel("MDBROILERPRODUCT");
            if (nwCode.length > 20) {
                mdbroilerProduct.setProperty("/code/state", "Error");
                mdbroilerProduct.setProperty("/code/stateText", "Excede el limite de caracteres permitido (20)");
                mdbroilerProduct.setProperty("/code/ok", false);
                mdbroilerProduct.setProperty("/nButton", false);
            } else {
                this.checkChange(input.getValue().toString(), "/code", "changeCode");
            }           
        },
        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function (name, field, funct) {
            let mdModel = this.getModel("MDBROILERPRODUCT");

            if (name == "" || name === null) {
                mdModel.setProperty(field+"/state", "Error");
                mdModel.setProperty(field+"/stateText", this.getI18n().getText("enter.FIELD"));
                mdModel.setProperty(field+"/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found;

                if (funct === "changeCode") {
                    found = await registers.find(element => (element.code).toLowerCase() === name.toLowerCase());
                } else {
                    found = await registers.find(element => (element.name).toLowerCase() === name.toLowerCase());
                }

                if (found === undefined) {
                    mdModel.setProperty(field+"/state", "Success");
                    mdModel.setProperty(field+"/stateText", "");
                    mdModel.setProperty(field+"/ok", true);
                    mdModel.setProperty(field+"/nButton", true);
                } else {
                    mdModel.setProperty(field+"/state", "Error");
                    mdModel.setProperty(field+"/stateText", (funct==="changeCode") ? "código ya existente" : "nombre ya existente");
                    mdModel.setProperty(field+"/ok", false);
                    mdModel.setProperty(field+"/nButton", false);
                }
            }
        },

        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato Entero
         * @param {char} o numero
         */
        validateIntInput: function (o) {
            let input = o.getSource();
            let length = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^[0-9]{1,${length}}$/`);
            if (regex.test(value)) {
                return true;
            } else {
                let aux = value.split("").filter(char => {
                    if (/^[0-9]$/.test(char)) {
                        if (char !== ".") {
                            return true;
                        }
                    }
                }).join("");

                value = aux.substring(0, length);

                if (value > 0) {
                    input.setValue(value);
                } else {
                    input.setValue("");
                }
                let origin = input.sId.split("--")[1];
                
                this.detectFailure(origin, value)

                return false;
            }
        },
        /**
         * Detecta la falla en la entrada de campo 
         * @param {String} origin campo
         * @param {string} value entrada 
         */
        detectFailure: function (origin, value) {
            let propertyTarget = (origin === "broilerProduct_name_input22") ? "/min_days" : "/days_eviction",
                mdbroilerproduct = this.getView().getModel("MDBROILERPRODUCT"),
                state = "None",
                stateText = "";

            
            if (origin === "broilerProduct_name_input22" && mdbroilerproduct.getProperty("/days_eviction/value") !== "") {
                state = (parseInt(value) >= parseInt(mdbroilerproduct.getProperty("/days_eviction/value"))) ? "Error" : "None";
                stateText = (parseInt(value) >= parseInt(mdbroilerproduct.getProperty("/days_eviction/value"))) ? "Debe ser menor que el máximo de desalojo" : "";
            }
            if (origin === "broilerProduct_days_input_max" && mdbroilerproduct.getProperty("/min_days/value") !== "") {
                state = (parseInt(value) <= parseInt(mdbroilerproduct.getProperty("/min_days/value"))) ? "Error" : "None";
                stateText = (parseInt(value) <= parseInt(mdbroilerproduct.getProperty("/min_days/value"))) ? "Debe ser mayor que el mínimo de desalojo" : "";
            }
            
            mdbroilerproduct.setProperty(propertyTarget + "/state", state);
            mdbroilerproduct.setProperty(propertyTarget + "/stateText", stateText);
        },
        
        /**
         * Detecta la falla en la entrada de campo 
         * @param {String} origin campo
         * @param {string} value entrada 
         */
        detectFailure_C_W: function (origin, value) {
            let propertyTarget = (origin === "broilerProduct_weight_input") ? "/weight" : "/conver",
                mdbroilerproduct = this.getView().getModel("MDBROILERPRODUCT"),
                state = "None",
                stateText = "";
            
            mdbroilerproduct.setProperty(propertyTarget + "/state", state);
            mdbroilerproduct.setProperty(propertyTarget + "/stateText", stateText);
        }

    });
});