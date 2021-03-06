sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/Text",
    "sap/ui/model/Filter",
], function(BaseController, JSONModel,Dialog,Button, Text, Filter) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.ospartnership", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function() {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("ospartnership").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("ospartnership_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("ospartnership_Create").attachPatternMatched(this._onCreateMatched, this);
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
             * @type {JSONModel} MDOSPARTNERSHIP        Referencia al modelo "ospartnership"
             */

            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP");

            //dependiendo del dispositivo, establece la propiedad "phone"
            this.getView().getModel("util").setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");


            //establece ospartnership como la entidad seleccionada
            util.setProperty("/selectedEntity/", "ospartnership");
            ospartnership.setProperty("/settings/tableMode", "None");
            ospartnership.setProperty("/itemType", "DetailAndActive");
            

            //obtiene los registros de ospartnership
            this.onRead(that, util, ospartnership);
        },
        /**
         * Obtiene todos los registros de ospartnership
         * @param  {Controller} that         Referencia al controlador que llama esta función
         * @param  {JSONModel} util         Referencia al modelo "util"
         * @param  {JSONModel} ospartnership Referencia al modelo "ospartnership"
         */
        onRead: function(that, util, ospartnership) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl+"/partnership",
                method: "GET",
                success: function(res) {
                    util.setProperty("/busy/", false);
                    ospartnership.setProperty("/records/", res.data);

                },
                error: function(err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };
            util.setProperty("/busy/", true);
            //borra los registros OSPARTNERSHIP que estén almacenados actualmente
            ospartnership.setProperty("/records/", []);
            //realiza la llamada ajax
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
         * Inicializar la busqueda
         *
         */
        resetSearch: function(){
            this.getView().byId("partnershipSearchField").setValue("");
            this.onPartnershipSearch();
        },
        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function() {
            /**
             * @type {JSONModel} ospartnership Referencia al modelo "ospartnership"
             */
            var ospartnership = this.getView().getModel("OSPARTNERSHIP");

            ospartnership.setProperty("/stage_id/value", "");

            ospartnership.setProperty("/name/editable", true);
            ospartnership.setProperty("/name/value", "");
            ospartnership.setProperty("/name/state", "None");
            ospartnership.setProperty("/name/stateText", "");

            ospartnership.setProperty("/code/editable", true);
            ospartnership.setProperty("/code/value", "");
            ospartnership.setProperty("/code/state", "None");
            ospartnership.setProperty("/code/stateText", "");

            ospartnership.setProperty("/description/editable", true);
            ospartnership.setProperty("/description/value", "");
            ospartnership.setProperty("/description/state", "None");
            ospartnership.setProperty("/description/stateText", "");

            ospartnership.setProperty("/address/editable", true);
            ospartnership.setProperty("/address/value", "");
            ospartnership.setProperty("/address/state", "None");
            ospartnership.setProperty("/address/stateText", "");

            ospartnership.setProperty("/disable/value", false);
            ospartnership.setProperty("/saveEnabled", true);

        },
        /**
         * Habilita/deshabilita la edición de los datos de un registro ospartnership
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function(edit) {

            var ospartnership = this.getView().getModel("OSPARTNERSHIP");
            ospartnership.setProperty("/name/editable", edit);
            ospartnership.setProperty("/code/editable", edit);
            ospartnership.setProperty("/description/editable", edit);
            ospartnership.setProperty("/address/editable", edit);
            ospartnership.setProperty("/disable/editable", edit);

        },
        /**
         * Habilita/deshabilita la edición de los datos de un registro ospartnership
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues2: function(edit) {

            var ospartnership = this.getView().getModel("OSPARTNERSHIP");
            ospartnership.setProperty("/code/editable", edit);
            ospartnership.setProperty("/name/editable", edit);
            ospartnership.setProperty("/description/editable", edit);
            ospartnership.setProperty("/address/editable", edit);
            ospartnership.setProperty("/disable/editable", edit);

        },
        /**
         * Se define un campo como obligatorio o no, de un registro ospartnership
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function(edit) {
            var ospartnership = this.getView().getModel("OSPARTNERSHIP");

            ospartnership.setProperty("/name/required", edit);
            ospartnership.setProperty("/code/required", edit);
            ospartnership.setProperty("/description/required", edit);
            ospartnership.setProperty("/address/required", edit);

        },
        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function(oEvent) {
            this.resetSearch();
            this.getRouter().navTo("ospartnership_Create", {}, false /*create history*/ );
        },
        /**
         * Cancela la creación de un registro ospartnership, y regresa a la vista principal
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

            this._resetRecordValues();
            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/ );
        },
        /**
         * Solicita al servicio correspondiente crear un registro ospartnership
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function(oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                var that = this,
                    util = this.getView().getModel("util"),
                    ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                    serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "name": ospartnership.getProperty("/name/value"),
                        "code": ospartnership.getProperty("/code/value"),
                        "description": ospartnership.getProperty("/description/value"),
                        "address": ospartnership.getProperty("/address/value"),
                        "os_disable": ospartnership.getProperty("/disable/value")
                        
                    }),
                    url: serviceUrl+"/partnership",
                    dataType: "json",
                    async: true,
                    success: function(data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("ospartnership", {}, true /*no history*/ );

                    },
                    error: function(error) {
                        that.onToast("Error: " + error.responseText);
                        console.log("Read failed ");
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
             * @type {JSONModel} ospartnership Referencia al modelo "ospartnership"
             * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
             */
            var ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                flag = true,
                that = this;

            if (ospartnership.getProperty("/name/value") === "") {
                flag = false;
                ospartnership.setProperty("/name/state", "Error");
                ospartnership.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                ospartnership.setProperty("/name/state", "None");
                ospartnership.setProperty("/name/stateText", "");
            }

            if (ospartnership.getProperty("/code/value") === "") {
                flag = false;
                ospartnership.setProperty("/code/state", "Error");
                ospartnership.setProperty("/code/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                ospartnership.setProperty("/code/state", "None");
                ospartnership.setProperty("/code/stateText", "");
            }

            if (ospartnership.getProperty("/description/value") === "") {
                flag = false;
                ospartnership.setProperty("/description/state", "Error");
                ospartnership.setProperty("/description/stateText", this.getI18n().getText("enter.FIELD"));
            }  else {
                ospartnership.setProperty("/description/state", "None");
                ospartnership.setProperty("/description/stateText", "");
            }

            if (ospartnership.getProperty("/address/value") === "") {
                flag = false;
                ospartnership.setProperty("/address/state", "Error");
                ospartnership.setProperty("/address/stateText", this.getI18n().getText("enter.FIELD"));
            }  else {
                ospartnership.setProperty("/address/state", "None");
                ospartnership.setProperty("/address/stateText", "");
            }

            return flag;
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
            var ospartnership = this.getView().getModel("OSPARTNERSHIP");
            ospartnership.setProperty("/save/", false);
            ospartnership.setProperty("/cancel/", false);
            ospartnership.setProperty("/modify/", true);
            ospartnership.setProperty("/delete/", true);

            this._editRecordValues(false);
            this._editRecordRequired(false);
        },
        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function(oEvent) {

            var ospartnership = this.getView().getModel("OSPARTNERSHIP");
            ospartnership.setProperty("/save/", true);
            ospartnership.setProperty("/cancel/", true);
            ospartnership.setProperty("/modify/", false);
            ospartnership.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues2(true);
        },

        /**
         * Cancela la edición de un registro ospartnership
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function(oEvent) {
            /** @type {JSONModel} ospartnership  Referencia al modelo ospartnership */

            let ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                copy = ospartnership.getProperty("/copy");
                
            ospartnership.setProperty("/partnership_id/value", copy.partnership_id);
            ospartnership.setProperty("/name/value", copy.name);
            ospartnership.setProperty("/disable/value", copy.os_disable);
            ospartnership.setProperty("/code/value", copy.code);
            ospartnership.setProperty("/description/value", copy.description);
            ospartnership.setProperty("/address/value", copy.address);
            
            ospartnership.setProperty("/name/state", "None");
            ospartnership.setProperty("/disable/state", "None");
            ospartnership.setProperty("/code/state", "None");
            ospartnership.setProperty("/description/state", "None");
            ospartnership.setProperty("/address/state", "None");
            
            ospartnership.setProperty("/name/stateText", "");
            ospartnership.setProperty("/disable/stateText", "");
            ospartnership.setProperty("/code/stateText", "");
            ospartnership.setProperty("/description/stateText", "");
            ospartnership.setProperty("/address/stateText", "");
            
            this.onView();
        },
        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function() {
            this._viewOptions();
        },
        /**
         * Solicita al servicio correspondiente actualizar un registro ospartnership
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function(oEvent) {
            /**
             * Si el registro que se quiere actualizar es válido y hubo algún cambio
             * con respecto a sus datos originales
             */
            if (this._validRecord() && this._recordChanged2()) {
                /**
                 * @type {JSONModel} ospartnership       Referencia al modelo "ospartnership"
                 * @type {JSONModel} util         Referencia al modelo "util"
                 * @type {Controller} that         Referencia a este controlador
                 */
                var ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                    util = this.getView().getModel("util"),
                    that = this,
                    serviceUrl = util.getProperty("/serviceUrl");

                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "partnership_id": ospartnership.getProperty("/partnership_id/value"),
                        "name": ospartnership.getProperty("/name/value"),
                        "code": ospartnership.getProperty("/code/value"),
                        "description": ospartnership.getProperty("/description/value"),
                        "address": ospartnership.getProperty("/address/value"),
                        "os_disable": ospartnership.getProperty("/disable/value")
                        
                    }),
                    url: serviceUrl+"/partnership/",
                    dataType: "json",
                    async: true,
                    success: function(data) {

                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("ospartnership", {}, true /*no history*/ );

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
             * @type {JSONModel} OSPARTNERSHIP Referencia al modelo "OSPARTNERSHIP"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                flag = false;

            if (ospartnership.getProperty("/name/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (ospartnership.getProperty("/code/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/code")) {
                flag = true;
            }

            if (ospartnership.getProperty("/description/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/description")) {
                flag = true;
            }

            if (ospartnership.getProperty("/address/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/address")) {
                flag = true;
            }

            if(!flag) this.onToast("No se detectaron cambios");

            return flag;
        },
        /**
         * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
         * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
         */
        _recordChanged2: function() {
            /**
             * @type {JSONModel} OSPARTNERSHIP Referencia al modelo "OSPARTNERSHIP"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                flag = false;

                if (ospartnership.getProperty("/disable/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/disable")) {
                flag = true;
            }

            if (ospartnership.getProperty("/description/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/description")) {
                flag = true;
            }

            if (ospartnership.getProperty("/address/value") !== ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/address")) {
                flag = true;
            }

            if(!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onPartnershipSearch: function(oEvent){
            var sQuery = this.getView().byId("partnershipSearchField").getValue().toString(),
                binding = this.getView().byId("partnershipTable").getBinding("items");

            if(sQuery){
                let code = new Filter("code", sap.ui.model.FilterOperator.Contains, sQuery);
                let name = new Filter("name", sap.ui.model.FilterOperator.Contains, sQuery);
                let description = new Filter("description", sap.ui.model.FilterOperator.Contains, sQuery);
                    
                var oFilter = new sap.ui.model.Filter({aFilters:[code,name,description], and:false});
            }
    
            binding.filter(oFilter);

        },

        /**
         * Verifica si la empresa esta en uso en otra entidad
         * @param {JSON} partnership_id
         */
        onVerifyIsUsed: async function(partnership_id){
            let ret;

            const response = await fetch("/partnership/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    partnership_id: partnership_id
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
        onConfirmDelete: async function(oEvent) {

            let that = this,
                util = this.getView().getModel("util"),
                ospartnership = that.getView().getModel("OSPARTNERSHIP"),
                partnership_id = ospartnership.getProperty("/partnership_id/value"),
                serviceUrl = util.getProperty("/serviceUrl");
            var oBundle = this.getView().getModel("i18n").getResourceBundle();
            var confirmation = oBundle.getText("confirmation");

            
            let cond = await this.onVerifyIsUsed(partnership_id);
            if(cond){
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new Text({
                        text: "No se puede eliminar la empresa, porque está siendo utilizada."
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
                        text: "¿Desea eliminar esta empresa?"
                    }),
    
                    beginButton: new Button({
                        text: "Si",
                        press: function() {
                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "partnership_id": partnership_id
                                }),
                                url: serviceUrl+"/partnership/",
                                dataType: "json",
                                async: true,
                                success: function(data) {
            
                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("ospartnership", {}, true);
                                    dialog.close();
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
        changeDescription: function(oEvent){
            let input= oEvent.getSource();
            let nwDescription = input.getValue();
            let ospartnership = this.getView().getModel("OSPARTNERSHIP");

            if (nwDescription.length > 100) {
                ospartnership.setProperty("/description/state", "Error");
                ospartnership.setProperty("/description/stateText", "Excede el limite de caracteres permitido (100)");
                ospartnership.setProperty("/description/ok", false);
            } else {
                this.checkChange2(nwDescription.toString(), "/description", "changeDescription");
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeAddress: function(oEvent){
            let input= oEvent.getSource();
            let nwAddress = input.getValue();
            let ospartnership = this.getView().getModel("OSPARTNERSHIP");

            if (nwAddress.length > 100) {
                ospartnership.setProperty("/address/state", "Error");
                ospartnership.setProperty("/address/stateText", "Excede el limite de caracteres permitido (100)");
                ospartnership.setProperty("/address/ok", false);
            } else {
                this.checkChange2(nwAddress.toString(), "/address", "changeAddress");
            }
        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange2: async function (name, field, funct) {
            let mdModel = this.getModel("OSPARTNERSHIP");

            if (name == "" || name === null) {
                mdModel.setProperty(field+"/state", "Error");
                mdModel.setProperty(field+"/stateText", (funct==="changeAddress") ? "El campo dirección no puede estar vacío" : "El campo descripción no puede estar vacío");
                mdModel.setProperty(field+"/ok", false);
            } else {
                mdModel.setProperty(field+"/state", "None");
                mdModel.setProperty(field+"/stateText", "");
                mdModel.setProperty(field+"/ok", true);
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: async function(oEvent){
            let input= oEvent.getSource(),
                nwCode = input.getValue();
            let ospartnership = this.getView().getModel("OSPARTNERSHIP");
            let excepcion = ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/")+"/name");

            if(nwCode.length>45){
                ospartnership.setProperty("/name/state", "Error");
                ospartnership.setProperty("/name/stateText", "Excede el límite de caracteres permitido (45)");
                ospartnership.setProperty("/name/ok", false);
            }else{
                await this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");
                this.EnableButtonSave()
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeCode: async function(oEvent){
            let input= oEvent.getSource(),
                nwCode = input.getValue().trim();
            input.setValue(input.getValue().trim());
            let ospartnership = this.getView().getModel("OSPARTNERSHIP");
            let excepcion = ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/")+"/code");

            if(nwCode.length>20){
                ospartnership.setProperty("/code/state", "Error");
                ospartnership.setProperty("/code/stateText", "Excede el límite de caracteres permitido (20)");
                ospartnership.setProperty("/code/ok", false);
            }else{
                await this.checkChange(input.getValue().toString(), excepcion.toString(), "/code", "changeCode");
                this.EnableButtonSave()
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
            let util = this.getModel("util");
            let mdModel = this.getModel("OSPARTNERSHIP");
            let serverName = "/breed/" + funct;
            if (name == "" || name === null) {
                mdModel.setProperty(field + "/state", "None");
                mdModel.setProperty(field + "/stateText", "");
                mdModel.setProperty(field + "/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found

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
        },

        /**
         * Valida que todos los campos esten lleno correctamente en estado success para habilitar el boton
         *
         */
        EnableButtonSave: function () {
            let name_ok = this.getModel('OSPARTNERSHIP').getProperty('/name/state') === 'None'|| this.getModel('OSPARTNERSHIP').getProperty('/name/state') === 'Success',
                code_ok = this.getModel('OSPARTNERSHIP').getProperty('/code/state') === 'None'|| this.getModel('OSPARTNERSHIP').getProperty('/code/state') === 'Success',
                ret = name_ok && code_ok;
            this.getModel("OSPARTNERSHIP").setProperty("/saveEnabled", ret);
        
        },
        

    });
});
