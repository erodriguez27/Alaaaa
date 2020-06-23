sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/Dialog",
    "sap/m/Text",
    "sap/m/Button"
], function(BaseController, JSONModel, Dialog, Text, Button) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.mdbreed", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function() {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("mdbreed").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("mdbreed_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("mdbreed_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function(oEvent) {
            /**
             * @type {Controller} that         Referencia a este controlador
             * @type {JSONModel} util         Referencia al modelo "util"
             * @type {JSONModel} OS            Referencia al modelo "OS"
             * @type {JSONModel} MDSTAGE        Referencia al modelo "MdSTAGE"
             */

            var that = this,
                util = this.getView().getModel("util"),
                mdbreed = this.getView().getModel("MDBREED");

            //dependiendo del dispositivo, establece la propiedad "phone"
            this.getView().getModel("util").setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            //establece MDSTAGE como la entidad seleccionada
            util.setProperty("/selectedEntity/", "mdbreed");


            //obtiene los registros de mdstage
            this.onRead(that, util, mdbreed);
        },
        /**
         * Obtiene todos los registros de MDSTAGE
         * @param  {Controller} that         Referencia al controlador que llama esta función
         * @param  {JSONModel} util         Referencia al modelo "util"
         * @param  {JSONModel} MDSTAGE Referencia al modelo "MDSTAGE"
         */
        onRead: function(that, util, mdbreed) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var service = util.getProperty("/serviceUrl");
            var settings = {
                url: service+"/breed",
                method: "GET",
                success: function(res) {
                    util.setProperty("/busy/", false);
                    mdbreed.setProperty("/records/", res.data);
                },
                error: function(err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                    //that.onConnectionError();
                }
            };
            util.setProperty("/busy/", true);
            mdbreed.setProperty("/records/", []);
            $.ajax(settings);
        },
        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: function(oEvent) {

            this._resetRecordValues();
            this._editRecordValues(true);
            this._editRecordRequired(true);
        },
        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function() {
            /**
             * @type {JSONModel} MDSTAGE Referencia al modelo "MDSTAGE"
             */
            var mdbreed = this.getView().getModel("MDBREED");

            mdbreed.setProperty("/breed_id/value", "");

            mdbreed.setProperty("/code/editable", true);
            mdbreed.setProperty("/code/value", "");
            mdbreed.setProperty("/code/state", "None");
            mdbreed.setProperty("/code/stateText", "");
            mdbreed.setProperty("/code/excepcion", "");
            mdbreed.setProperty("/code/ok", false);

            mdbreed.setProperty("/name/editable", true);
            mdbreed.setProperty("/name/value", "");
            mdbreed.setProperty("/name/state", "None");
            mdbreed.setProperty("/name/stateText", "");
            mdbreed.setProperty("/name/excepcion", "");
            mdbreed.setProperty("/name/ok", false);

        },
        /**
         * Habilita/deshabilita la edición de los datos de un registro MDSTAGE
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function(edit) {

            var mdbreed = this.getView().getModel("MDBREED");
            mdbreed.setProperty("/code/editable", edit);
            mdbreed.setProperty("/name/editable", edit);
            mdbreed.setProperty("/type/editable", edit);
        },
        /**
         * Se define un campo como obligatorio o no, de un registro MDSTAGE
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function(edit) {
            var mdbreed = this.getView().getModel("MDBREED");
            mdbreed.setProperty("/code/required", edit);
            mdbreed.setProperty("/name/required", edit);
        },
        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function(oEvent) {
            this.getRouter().navTo("mdbreed_Create", {}, false /*create history*/ );
        },
        /**
         * Cancela la creación de un registro MDSTAGE, y regresa a la vista principal
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
         * Solicita al servicio correspondiente crear un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function(oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                var that = this;
                var util = this.getView().getModel("util");
                var serviceUrl = util.getProperty("/serviceUrl");
                var mdbreed = this.getView().getModel("MDBREED");

                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "code": mdbreed.getProperty("/code/value"),
                        "name": mdbreed.getProperty("/name/value"),
                        "type": mdbreed.getProperty("/type/value"),
                    }),
                    url: serviceUrl+"/breed",
                    dataType: "json",
                    async: true,
                    success: function(data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("mdbreed", {}, true /*no history*/ );

                    },
                    error: function(request) {
                        //that.onToast('Error: ' + error.responseText);
                        var msg = "Error de comunicación";
                        if(request.responseJSON.code==23505)
                            msg = "El codigo "+mdbreed.getProperty("/code/value")+" ya se encuentra registrado en sistema";

                        that.onToast("Error: "+msg);
                        console.log("Read failed");
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
             * @type {JSONModel} MDBREED Referencia al modelo "MDBREED"
             * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
             */
            var mdstage = this.getView().getModel("MDBREED"),
                flag = true,
                that = this,
                Without_SoL = /^\d+$/,
                Without_Num = /^[a-zA-Z\s]*$/;

            if (mdstage.getProperty("/code/value") === "") {
                flag = false;
                mdstage.setProperty("/code/state", "Error");
                mdstage.setProperty("/code/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                mdstage.setProperty("/order_/state", "None");
                mdstage.setProperty("/order_/stateText", "");
            }

            if (mdstage.getProperty("/name/value") === "") {
                flag = false;
                mdstage.setProperty("/name/state", "Error");
                mdstage.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD"));
            }

            return flag;
        },
        /**
         * Visualiza los detalles de un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onViewBreedRecord: function(oEvent) {
            this._resetRecordValues();
            var mdbreed = this.getView().getModel("MDBREED");
            mdbreed.setProperty("/save/", false);
            mdbreed.setProperty("/cancel/", false);
            mdbreed.setProperty("/selectedRecordPath/", oEvent.getSource().getBindingContext("MDBREED"));
            mdbreed.setProperty("/breed_id/value", oEvent.getSource().getBindingContext("MDBREED").getObject().breed_id);
            mdbreed.setProperty("/code/value", oEvent.getSource().getBindingContext("MDBREED").getObject().code);
            mdbreed.setProperty("/code/excepcion", oEvent.getSource().getBindingContext("MDBREED").getObject().code);
            mdbreed.setProperty("/name/value", oEvent.getSource().getBindingContext("MDBREED").getObject().name);
            mdbreed.setProperty("/name/excepcion", oEvent.getSource().getBindingContext("MDBREED").getObject().name);
            mdbreed.setProperty("/type/value", oEvent.getSource().getBindingContext("MDBREED").getObject().type);
            this.getRouter().navTo("mdbreed_Record", {}, false /*create history*/ );
            mdbreed.setProperty("/name/ok", true);
            mdbreed.setProperty("/code/ok", true);
        },
        onbroilerProductSearch: function(oEvent){
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("brredTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {
                /** @type {Object} filter1 Primer filtro de la búsqueda */
                var filter1 = new sap.ui.model.Filter("name", sap.ui.model.FilterOperator.Contains, sQuery);
                aFilters = new sap.ui.model.Filter([filter1]);
            }

            //se actualiza el binding de la lista
            binding.filter(aFilters);

        },
        /**
         * Coincidencia de ruta para acceder a los detalles de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRecordMatched: function(oEvent) {

            this._viewOptions();

        },
        /**
         * Cambia las opciones de visualización disponibles en la vista de detalles de un registro
         */
        _viewOptions: function() {
            var mdstage = this.getView().getModel("MDBREED");
            mdstage.setProperty("/save/", false);
            mdstage.setProperty("/cancel/", false);
            mdstage.setProperty("/modify/", true);
            mdstage.setProperty("/delete/", true);

            this._editRecordValues(false);
            this._editRecordRequired(false);
        },
        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function(oEvent) {

            var mdstage = this.getView().getModel("MDBREED");
            mdstage.setProperty("/save/", true);
            mdstage.setProperty("/cancel/", true);
            mdstage.setProperty("/modify/", false);
            mdstage.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues(true);
        },

        /**
         * Cancela la edición de un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function(oEvent) {
            /** @type {JSONModel} MDSTAGE  Referencia al modelo MDSTAGE */

            var mdbreed = this.getView().getModel("MDBREED");
            mdbreed.setProperty("/name/value",mdbreed.getProperty(mdbreed.getProperty("/selectedRecordPath/")+"/name"));
            mdbreed.setProperty("/code/value",mdbreed.getProperty(mdbreed.getProperty("/selectedRecordPath/")+"/code"));

            this.onView();
        },
        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function() {
            this._viewOptions();
        },
        /**
         * Solicita al servicio correspondiente actualizar un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function(oEvent) {
            /**
             * Si el registro que se quiere actualizar es válido y hubo algún cambio
             * con respecto a sus datos originales
             */
            if (this._validRecord() && this._recordChanged()) {
                /**
                 * @type {JSONModel} MDSTAGE       Referencia al modelo "MDSTAGE"
                 * @type {JSONModel} util         Referencia al modelo "util"
                 * @type {Controller} that         Referencia a este controlador
                 */
                var mdbreed = this.getView().getModel("MDBREED");
                var util = this.getView().getModel("util");
                var serviceUrl = util.getProperty("/serviceUrl");
                var that = this;
                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "breed_id": mdbreed.getProperty("/breed_id/value"),
                        "code": mdbreed.getProperty("/code/value"),
                        "name": mdbreed.getProperty("/name/value"),
                        "type": mdbreed.getProperty("/type/value"),
                    }),
                    url: serviceUrl+"/breed/",
                    dataType: "json",
                    async: true,
                    success: function(data) {

                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("mdbreed", {}, true /*no history*/ );

                    },
                    error: function(request, status, error) {
                        var msg = "Error de comunicación";
                        if(request.responseJSON.code==23505)
                            msg = "El codigo "+mdbreed.getProperty("/code/value")+" ya se encuentra registrado en sistema";

                        that.onToast("Error: "+msg);
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
             * @type {JSONModel} MDBREED         Referencia al modelo "MDSTAGE"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var mdbreed = this.getView().getModel("MDBREED"),
                flag = false;

            if (mdbreed.getProperty("/code/value") !== mdbreed.getProperty(mdbreed.getProperty("/selectedRecordPath/") + "/code")) {
                flag = true;
            }

            if (mdbreed.getProperty("/name/value") !== mdbreed.getProperty(mdbreed.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (mdbreed.getProperty("/type/value") !== mdbreed.getProperty(mdbreed.getProperty("/selectedRecordPath/") + "/type")) {
                flag = true;
            }


            if(!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onbreedSearch: function(oEvent){
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("brredTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {
                /** @type {Object} filter1 Primer filtro de la búsqueda */
                var filter1 = new sap.ui.model.Filter("type", sap.ui.model.FilterOperator.Contains, sQuery);
                aFilters = new sap.ui.model.Filter([filter1]);
            }

            //se actualiza el binding de la lista
            binding.filter(aFilters);

        },

        /**
         * Verifica si la raza esta en uso 
         * @param {JSON} breed_id
         */
        onVerifyIsUsed: async function(breed_id){
            let ret;
        
            const response = await fetch("/breed/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    breed_id: breed_id
                })
            });
        
            if (response.status !== 200 && response.status !== 409) {
                console.log("Looks like there was a problem. Status Code: " +
                    response.status);
                return;
            }
            if(response.status === 200){
                const res = await response.json();
                ret = res.data.used;
            }
            return ret;
            
        },

        /**
         * Levanta el Dialogo que muestra la confirmacion del Eliminar un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function(oEvent){

            let oBundle = this.getView().getModel("i18n").getResourceBundle(),
                confirmation = oBundle.getText("confirmation"),
                mdbreed = this.getView().getModel("MDBREED"),
                util = this.getView().getModel("util"),
                serviceUrl = util.getProperty("/serviceUrl"),
                that = this,
                breed_id = mdbreed.getProperty("/breed_id/value");

            let cond = await this.onVerifyIsUsed(breed_id);
            if(cond){
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new Text({
                        text: "No se puede eliminar la Raza, porque está siendo utilizada."
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
            }else{
                var dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Seguro que desea eliminar esta raza?"
                    }),

                    beginButton: new Button({
                        text: "Si",
                        press: function() {
                            util.setProperty("/busy/", true);
                                

                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "breed_id": breed_id
                                }),
                                url: serviceUrl+"/breed/",
                                dataType: "json",
                                async: true,
                                success: function(data) {

                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("mdbreed", {}, true);
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
            let input= oEvent.getSource(),
                nwCode = input.getValue();

            let mdbreed= this.getModel("MDBREED");
            let excepcion= mdbreed.getProperty("/name/excepcion");

            if(nwCode.length>45){
                mdbreed.setProperty("/name/state", "Error");
                mdbreed.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                mdbreed.setProperty("/name/ok", false);
            }else{
                this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");

            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeCode: function(oEvent){
            let input= oEvent.getSource(),
                nwCode = input.getValue().trim();
            input.setValue(input.getValue().trim());
            let mdbreed= this.getModel("MDBREED");
            let excepcion= mdbreed.getProperty("/code/excepcion");
            if(nwCode.length>20){
                mdbreed.setProperty("/code/state", "Error");
                mdbreed.setProperty("/code/stateText", "Excede el limite de caracteres permitido (20)");
                mdbreed.setProperty("/code/ok", false);
            }else{

                this.checkChange(input.getValue().toString(), excepcion.toString(), "/code", "changeCode");
            }

        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} excepcion excepcion del modelo 
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function (name, excepcion, field, funct) {
            let mdModel = this.getModel("MDBREED");
            if (name == "" || name === null) {
                mdModel.setProperty(field + "/state", "None");
                mdModel.setProperty(field + "/stateText", "");
                mdModel.setProperty(field + "/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found;
                //toLowerCase se tranforma todo en minusculas y se compara que lo escrito no sea igual a lo que ya esta en bd 
                if (funct === "changeCode") {
                    found = await registers.find(element => ((element.code).toLowerCase() === name.toLowerCase() && element.code !== excepcion));
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
