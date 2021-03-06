sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/MessageToast"
], function (BaseController, JSONModel, Dialog, Button, MessageToast) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.osIncubator", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function () {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("osIncubator").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("osIncubator_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("osIncubator_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function (oEvent) {
            /**
             * @type {Controller} that          Referencia a este controlador
             * @type {JSONModel} dummy          Referencia al modelo "dummy"
             * @type {JSONModel} OS             Referencia al modelo "OS"
             * @type {JSONModel} PARTNERSHIP  Referencia al modelo "PARTNERSHIP"
             * @type {JSONModel} BROILERSFARM Referencia al modelo "BROILERSFARM"
             * @type {JSONModel} CENTER       Referencia al modelo "CENTER"
             */

            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                osincubatorplant = this.getView().getModel("OSINCUBATORPLANT"),
                osincubator = this.getView().getModel("OSINCUBATOR");

            ospartnership.setProperty("/itemType", "Inactive");
            osincubatorplant.setProperty("/itemType", "Inactive");

            //dependiendo del dispositivo, establece la propiedad "phone"
            util.setProperty("/phone/", this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");


            ospartnership.setProperty("/settings/tableMode", "SingleSelect");
            osincubatorplant.setProperty("/settings/tableMode", "SingleSelect");
            osincubator.setProperty("/settings/tableMode", "None");

            //si la entidad seleccionada antes de acceder a esta vista es diferente a CENTER
            if (util.getProperty("/selectedEntity") !== "osIncubator") {
                //establece CENTER como la entidad seleccionada
                util.setProperty("/selectedEntity", "osIncubator");
                //establece el tab de la tabla PARTNERSHIP como el tab seleccionado
                this.getView().byId("tabBar").setSelectedKey("kpartnershipFilter");
                //limpio selectedRecord
                ospartnership.setProperty("/selectedRecord", "");
                osincubatorplant.setProperty("/selectedRecord", "");
                //borra cualquier selección que se haya hecho en la tabla PARTNERSHIP
                this.getView().byId("partnershipTable").removeSelections(true);
                //borra cualquier selección que se haya hecho en la tabla incubatorPlant
                this.getView().byId("incubatorPlantTable").removeSelections(true);
                //establece que no hay ningún registro PARTNERSHIP seleccionado
                ospartnership.setProperty("/selectedRecordPath/", "");
                //establece que no hay ningún registro BROILERSFARM seleccionado
                osincubatorplant.setProperty("/selectedRecordPath/", "");
                osincubatorplant.setProperty("/records/", []);
                osincubator.setProperty("/records/", []);
                //deshabilita el tab de la tabla de registros incubatorPLant
                osincubatorplant.setProperty("/settings/enabledTab", false);
                //deshabilita el tab de la tabla de registros CENTER
                osincubator.setProperty("/settings/enabledTab", false);
                //deshabilita la opción de crear un registro CENTER
                osincubator.setProperty("/new", false);
                //obtiene los registros de PARTNERSHIP
                sap.ui.controller("technicalConfiguration.controller.ospartnership").onRead(that, util, ospartnership);
            } else if (ospartnership.getProperty("/selectedRecordPath/") !== "" && osincubatorplant.getProperty("/selectedRecordPath/") !== "") {
                //habilita el tab de la tabla de registros BROILERSFARM
                osincubatorplant.setProperty("/settings/enabledTab", true);
                //habilita el tab de la tabla de registros CENTER
                osincubator.setProperty("/settings/enabledTab", true);
                //habilita la opción de crear un registro CENTER
                osincubator.setProperty("/new", true);
                //obtiene los registros de CENTER
                this.onRead(that, util, ospartnership, osincubatorplant, osincubator);
            }
        },

        /**
         * Funcion para detectar el cambio de iconos en el tabbar
         *
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onSelectChangedTab: function (oEvent) {
            let osincubator = this.getView().getModel("OSINCUBATOR");

            let key = (oEvent.getParameters().selectedKey).split("--");
            if (key[0] !== "kincubatorFilter") {
                osincubator.setProperty("/new", false);
            } else {
                osincubator.setProperty("/new", true);
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
                let aux = value
                    .split("")
                    .filter(char => {
                        if (/^[0-9]$/.test(char)) {
                            if (char !== ".") {
                                return true;
                            }
                        }
                    })
                    .join("");
                value = aux.substring(0, length);
                input.setValue(value);

                if (parseInt(value) === 0) {
                    input.setValueState("Error");
                    input.setValueStateText("El campo capacidad debe ser mayor a cero (0)");
                } else {
                    input.setValueState("None");
                    input.setValueStateText("");
                }

                return false;
            }
        },

        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato Entero
         * @param {char} o numero
         */
        validateOrderIntInput: function (o) {
            let input = o.getSource();
            let length = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^[0-9]{1,${length}}$/`);
            let osincubator = this.getView().getModel("OSINCUBATOR");
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
                input.setValue(value);
                if (value !== undefined && value !== null && value !== "") {
                    value = parseInt(value);
                    let records = osincubator.getProperty("/records"),
                        used = false;
                    records.forEach(itm => {
                        used = used || (itm._order === value)
                    });
                    if (used === true) {
                        osincubator.setProperty("/order/state", "Error");
                        osincubator.setProperty("/order/stateText", "El orden ingresado ya fue utilizado");
                        osincubator.setProperty("/name/ok", false);
                        osincubator.setProperty("/saveEnabled", false);

                    } else {
                        osincubator.setProperty("/order/state", "Success");
                        osincubator.setProperty("/order/stateText", "");
                        osincubator.setProperty("/name/ok", true);
                        osincubator.setProperty("/saveEnabled", true);
                    }
                } else {
                    osincubator.setProperty("/order/state", "None");
                    osincubator.setProperty("/order/stateText", "");
                    osincubator.setProperty("/name/ok", true);
                    osincubator.setProperty("/saveEnabled", true);
                }
                return false;
            }
        },



        /**
         * Seleccion en la tabla partnership
         * @param {Event} oEvent Evento que llamó esta función
         */
        onSelectPartnershipRecord: function (oEvent) {

            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                osincubatorplant = this.getView().getModel("OSINCUBATORPLANT");

            //guarda la ruta del registro PARTNERSHIP que fue seleccionado
            ospartnership.setProperty("/selectedRecordPath/", oEvent.getSource()["_aSelectedPaths"][0]);
            ospartnership.setProperty("/selectedRecord/", ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/")));

            //habilita el tab de la tabla de registros BROILERSFARM
            osincubatorplant.setProperty("/settings/enabledTab", true);

            //habilita la opción de crear un registro BROILERSFARM
            osincubatorplant.setProperty("/new", true);

            //establece el tab de la tabla incubatorPlant como el tab seleccionado
            this.getView().byId("tabBar").setSelectedKey("kincubatorPlantFilter");


            sap.ui.controller("technicalConfiguration.controller.osIncubatorPlant").onRead(that, util, ospartnership, osincubatorplant);


        },

        /**
         * Seleccion en la tabla incubatorplant
         * @param {Event} oEvent Evento que llamó esta función
         */
        onSelectIncubatorPlantRecord: function (oEvent) {
            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                osincubatorplant = this.getView().getModel("OSINCUBATORPLANT"),
                osincubator = this.getView().getModel("OSINCUBATOR");

            //guarda la ruta del registro BROILERSFARM que fue seleccionado
            osincubatorplant.setProperty("/selectedRecordPath/", oEvent.getSource()["_aSelectedPaths"][0]);

            osincubatorplant.setProperty("/selectedRecord/", osincubatorplant.getProperty(osincubatorplant.getProperty("/selectedRecordPath/")));

            //habilita el tab de la tabla de registros CENTER
            osincubator.setProperty("/settings/enabledTab", true);

            //habilita la opción de crear un registro CENTER
            osincubator.setProperty("/new", true);

            //establece el tab de la tabla CENTER como el tab seleccionado
            this.getView().byId("tabBar").setSelectedKey("kincubatorFilter");

            //obtiene los registros de CENTER
            this.onRead(that, util, ospartnership, osincubatorplant, osincubator);
        },

        /**
         * Obtiene todos los registros de OSINCUBATOR, dado un cliente y una sociedad
         * @param  {Controller} that          Referencia al controlador que llama esta función
         * @param  {JSONModel} util          Referencia al modelo "util"
         * @param  {JSONModel} PARTNERSHIP  Referencia al modelo "PARTNERSHIP"
         * @param  {JSONModel} OSINCUBATORPLANT Referencia al modelo "OSINCUBATORPLANT"
         * @param  {JSONModel} OSINCUBATOR       Referencia al modelo "OSINCUBATOR"
         */
        onRead: function (that, util, ospartnership, osincubatorplant, osincubator) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var serviceUrl = util.getProperty("/serviceUrl");
            var incubator_plant_id = osincubatorplant.getProperty(osincubatorplant.getProperty("/selectedRecordPath/") + "/incubator_plant_id");
            var settings = {
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    "incubator_plant_id": incubator_plant_id,
                }),
                url: serviceUrl + "/incubator/findIncubatorByPlant",
                dataType: "json",
                async: true,
                success: function (res) {
                    util.setProperty("/busy/", false);
                    osincubator.setProperty("/records/", res.data);

                },
                error: function (err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                    //that.onConnectionError();
                }
            };
            util.setProperty("/busy/", true);
            //borra los registros CENTER que estén almacenados actualmente
            osincubator.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onPartnershipSearch: function (oEvent) {
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("partnershipTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {

                aFilters = new sap.ui.model.Filter({
                    filters: [
                        new sap.ui.model.Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                        new sap.ui.model.Filter("code", sap.ui.model.FilterOperator.Contains, sQuery)
                    ],
                    and: false
                });
            }

            //se actualiza el binding de la lista
            binding.filter(aFilters);

        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onIncubatorPlantSearch: function (oEvent) {
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("incubatorPlantTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {

                aFilters = new sap.ui.model.Filter({
                    filters: [
                        new sap.ui.model.Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                        new sap.ui.model.Filter("code", sap.ui.model.FilterOperator.Contains, sQuery)
                    ],
                    and: false
                });
            }
            //se actualiza el binding de la lista
            binding.filter(aFilters);

        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onIncubatorSearch: function (oEvent) {
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("incubatorTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {
                /** @type {Object} filter1 Primer filtro de la búsqueda */
                // var filter1 = new sap.ui.model.Filter("name", sap.ui.model.FilterOperator.Contains, sQuery);
                // var filter2 = new sap.ui.model.Filter("code", sap.ui.model.FilterOperator.Contains, sQuery);
                // aFilters = new sap.ui.model.Filter([filter1,filter2]);
                aFilters = new sap.ui.model.Filter({
                    filters: [
                        new sap.ui.model.Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                        new sap.ui.model.Filter("code", sap.ui.model.FilterOperator.Contains, sQuery)
                    ],
                    and: false
                });
            }

            //se actualiza el binding de la lista
            binding.filter(aFilters);

        },

        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function (oEvent) {
            this.getRouter().navTo("osIncubator_Create", {}, false /*create history*/ );
        },

        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: function (oEvent) {
            this._resetRecordValues();
            this._editRecordValues(true);
            this._editRecordRequired(true);
        },

        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function () {
            /**
             * @type {JSONModel} OSINCUBATORPLANT Referencia al modelo "OSINCUBATORPLANT"
             */
            var osincubator = this.getView().getModel("OSINCUBATOR");

            osincubator.setProperty("/name/editable", true);
            osincubator.setProperty("/name/value", "");
            osincubator.setProperty("/name/state", "None");
            osincubator.setProperty("/name/stateText", "");

            osincubator.setProperty("/code/editable", true);
            osincubator.setProperty("/code/value", "");
            osincubator.setProperty("/code/state", "None");
            osincubator.setProperty("/code/stateText", "");

            osincubator.setProperty("/description/editable", true);
            osincubator.setProperty("/description/value", "");
            osincubator.setProperty("/description/state", "None");
            osincubator.setProperty("/description/stateText", "");

            osincubator.setProperty("/capacity/editable", true);
            osincubator.setProperty("/capacity/value", "");
            osincubator.setProperty("/capacity/state", "None");
            osincubator.setProperty("/capacity/stateText", "");

            osincubator.setProperty("/order/editable", true);
            osincubator.setProperty("/order/value", "");
            osincubator.setProperty("/order/state", "None");
            osincubator.setProperty("/order/stateText", "");

            osincubator.setProperty("/sunday/enabled", true);
            osincubator.setProperty("/sunday/value", false);

            osincubator.setProperty("/monday/enabled", true);
            osincubator.setProperty("/monday/value", false);

            osincubator.setProperty("/tuesday/enabled", true);
            osincubator.setProperty("/tuesday/value", false);

            osincubator.setProperty("/wednesday/enabled", true);
            osincubator.setProperty("/wednesday/value", false);

            osincubator.setProperty("/thursday/enabled", true);
            osincubator.setProperty("/thursday/value", false);

            osincubator.setProperty("/friday/enabled", true);
            osincubator.setProperty("/friday/value", false);

            osincubator.setProperty("/saturday/enabled", true);
            osincubator.setProperty("/saturday/value", false);

        },

        /**
         * Habilita/deshabilita la edición de los datos de un registro OSINCUBATORPLANT
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function (edit) {

            var osincubator = this.getView().getModel("OSINCUBATOR");
            osincubator.setProperty("/name/editable", edit);
            osincubator.setProperty("/code/editable", edit);
            osincubator.setProperty("/description/editable", edit);
            osincubator.setProperty("/capacity/editable", edit);
            osincubator.setProperty("/order/editable", edit);

            osincubator.setProperty("/sunday/enabled", edit);
            osincubator.setProperty("/monday/enabled", edit);
            osincubator.setProperty("/tuesday/enabled", edit);
            osincubator.setProperty("/wednesday/enabled", edit);
            osincubator.setProperty("/thursday/enabled", edit);
            osincubator.setProperty("/friday/enabled", edit);
            osincubator.setProperty("/saturday/enabled", edit);

        },
        /**
         * Se define un campo como obligatorio o no, de un registro MDSTAGE
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function (edit) {
            var osincubator = this.getView().getModel("OSINCUBATOR");
            osincubator.setProperty("/name/required", edit);
            osincubator.setProperty("/code/required", edit);
            osincubator.setProperty("/description/required", edit);
            osincubator.setProperty("/capacity/required", edit);
            osincubator.setProperty("/order/required", edit);

        },
        /**
         * Solicita al servicio correspondiente crear un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function (oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                var osincubator = this.getView().getModel("OSINCUBATOR"),
                    osincubatorplant = this.getView().getModel("OSINCUBATORPLANT"),
                    util = this.getView().getModel("util"),
                    that = this,
                    serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "incubator_plant_id": osincubatorplant.getProperty(osincubatorplant.getProperty("/selectedRecordPath/") + "/incubator_plant_id"),
                        "name": osincubator.getProperty("/name/value"),
                        "code": osincubator.getProperty("/code/value"),
                        "description": osincubator.getProperty("/description/value"),
                        "capacity": osincubator.getProperty("/capacity/value"),
                        "order": osincubator.getProperty("/order/value"),
                        "sunday": osincubator.getProperty("/sunday/value") == true ? 1 : 0,
                        "monday": osincubator.getProperty("/monday/value") == true ? 1 : 0,
                        "tuesday": osincubator.getProperty("/tuesday/value") == true ? 1 : 0,
                        "wednesday": osincubator.getProperty("/wednesday/value") == true ? 1 : 0,
                        "thursday": osincubator.getProperty("/thursday/value") == true ? 1 : 0,
                        "friday": osincubator.getProperty("/friday/value") == true ? 1 : 0,
                        "saturday": osincubator.getProperty("/saturday/value") == true ? 1 : 0,
                        "available": osincubator.getProperty("/capacity/value")
                    }),
                    url: serviceUrl + "/incubator/",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("osIncubator", {}, true /*no history*/ );

                    },
                    error: function (error) {
                        that.onToast("Error: " + error.responseText);
                    }
                });

            }
        },

        /**
         * Valida la correctitud de los datos existentes en el formulario del registro
         * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
         */
        _validRecord: function () {
            var osincubator = this.getView().getModel("OSINCUBATOR"),
                flag = true;

            if (osincubator.getProperty("/name/value") === "") {
                flag = false;
                osincubator.setProperty("/name/state", "Error");
                osincubator.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (osincubator.getProperty("/name/state") === "Error") {
                flag = false;
            } else {
                osincubator.setProperty("/name/state", "None");
                osincubator.setProperty("/name/stateText", "");
            }

            if (osincubator.getProperty("/code/value") === "") {
                flag = false;
                osincubator.setProperty("/code/state", "Error");
                osincubator.setProperty("/code/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (osincubator.getProperty("/code/state") === "Error") {
                flag = false;
            } else {
                osincubator.setProperty("/code/state", "None");
                osincubator.setProperty("/code/stateText", "");
            }

            if (osincubator.getProperty("/description/value") === "") {
                flag = false;
                osincubator.setProperty("/description/state", "Error");
                osincubator.setProperty("/description/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (osincubator.getProperty("/description/state") === "Error") {
                flag = false;
            } else {
                osincubator.setProperty("/description/state", "None");
                osincubator.setProperty("/description/stateText", "");
            }

            if (osincubator.getProperty("/capacity/value") === "" || parseInt(osincubator.getProperty("/capacity/value")) === 0) {
                flag = false;
                osincubator.setProperty("/capacity/state", "Error");
                osincubator.setProperty("/capacity/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                if (osincubator.getProperty("/capacity/value") > 2147483647) {
                    osincubator.setProperty("/capacity/state", "Error");
                    osincubator.setProperty("/capacity/stateText", "Supera el límite establecido (2147483647)");
                    flag = false;
                } else {
                    osincubator.setProperty("/capacity/state", "None");
                    osincubator.setProperty("/capacity/stateText", "");

                }
            }

            if (osincubator.getProperty("/order/value") === "") {
                flag = false;
                osincubator.setProperty("/order/state", "Error");
                osincubator.setProperty("/order/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (osincubator.getProperty("/order/state") === "Error") {
                flag = false;
            } else {
                osincubator.setProperty("/order/state", "None");
                osincubator.setProperty("/order/stateText", "");
            }

            if (!this.verifyDaysSelected()) {
                flag = false;
                MessageToast.show("Debe indicar al menos un día de trabajo", {
                    duration: 3000,
                    width: "20%"
                });
            }

            return flag;
        },

        /**
         * verifica los dias seleccionado para las maquinas encubadoras
         *
         * @returns {Boolean} true si esta seleccionado, false default
         */
        verifyDaysSelected: function () {
            let aDay = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];
            let osincubator = this.getView().getModel("OSINCUBATOR");
            let ret = false;

            for (let i = 0; i < aDay.length; i++) {
                ret = ret || osincubator.getProperty("/" + aDay[i] + "/value");
            }

            return ret;
        },

        /**
         * Regresa a la vista principal de la entidad seleccionada actualmente
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNavBack: function (oEvent) {
            let util = this.getView().getModel("util");

            this._resetRecordValues();
            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/ );
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
            var osincubator = this.getView().getModel("OSINCUBATOR");
            osincubator.setProperty("/save/", false);
            osincubator.setProperty("/cancel/", false);
            osincubator.setProperty("/modify/", true);
            osincubator.setProperty("/delete/", true);
            this._editRecordValues(false);
            this._editRecordRequired(false);
        },

        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function (oEvent) {
            var osincubator = this.getView().getModel("OSINCUBATOR");
            osincubator.setProperty("/save/", true);
            osincubator.setProperty("/cancel/", true);
            osincubator.setProperty("/modify/", false);
            osincubator.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues(true);
        },

        /**
         * Cancela la edición de un registro OSINCUBATORPLANT
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function (oEvent) {
            let osincubator = this.getView().getModel("OSINCUBATOR");
            let copy = osincubator.getProperty("/copy");

            osincubator.setProperty("/name/value", copy.name);
            osincubator.setProperty("/code/value", copy.code);
            osincubator.setProperty("/description/value", copy.description);
            osincubator.setProperty("/order/value", copy.order);
            osincubator.setProperty("/capacity/value", copy.capacity);
            osincubator.setProperty("/sunday/value", copy.sunday);
            osincubator.setProperty("/monday/value", copy.monday);
            osincubator.setProperty("/tuesday/value", copy.tuesday);
            osincubator.setProperty("/wednesday/value", copy.wednesday);
            osincubator.setProperty("/thursday/value", copy.thursday);
            osincubator.setProperty("/friday/value", copy.friday);
            osincubator.setProperty("/saturday/value", copy.saturday);
            osincubator.setProperty("/available/value", copy.available);
            osincubator.setProperty("/name/state", "None");
            osincubator.setProperty("/name/stateText", "");
            osincubator.setProperty("/code/state", "None");
            osincubator.setProperty("/code/stateText", "");
            osincubator.setProperty("/description/state", "None");
            osincubator.setProperty("/description/stateText", "");
            osincubator.setProperty("/order/state", "None");
            osincubator.setProperty("/order/stateText", "");
            osincubator.setProperty("/capacity/state", "None");
            osincubator.setProperty("/capacity/stateText", "");

            this.onView();
        },

        /**
         * Cancela la creación de un registro OSINCUBATORPLANT, y regresa a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelCreate: function (oEvent) {
            this._resetRecordValues();
            this.onNavBack(oEvent);
        },

        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function () {
            this._viewOptions();
        },

        /**
         * Levanta el Dialogo que muestra la confirmacion del Eliminar un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function (oEvent) {

            let that = this,
                util = this.getView().getModel("util"),
                osIncubator = that.getView().getModel("OSINCUBATOR"),
                serviceUrl = util.getProperty("/serviceUrl");
            var oBundle = this.getView().getModel("i18n").getResourceBundle();
            var confirmation = oBundle.getText("confirmation");
            var incubator_id = osIncubator.getProperty(osIncubator.getProperty("/selectedRecordPath/") + "/incubator_id");

            util.setProperty("/busy/", true);

            let cond = await this.onVerifyIsUsed(incubator_id);

            if (cond) {
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new sap.m.Text({
                        text: "No se puede eliminar la Máquina de Incubación, porque está siendo utilizada."
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
                var dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Desea eliminar esta Máquina de Incubación?"
                    }),

                    beginButton: new Button({
                        text: "Si",
                        press: function () {

                            util.setProperty("/busy/", true);
                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "incubator_id": incubator_id
                                }),
                                url: serviceUrl + "/incubator/",
                                dataType: "json",
                                async: true,
                                success: function (data) {
                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("osIncubator", {}, true);
                                    dialog.close();
                                },
                                error: function (request, status, error) {
                                    that.onToast("Error de comunicación");
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
         * Verifica si la Planta Incubadora esta en uso 
         * @param {JSON} incubator_id
         */
        onVerifyIsUsed: async function (incubator_id) {
            let ret;
            const response = await fetch("/process/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    incubator_id: incubator_id
                })
            });

            if (response.status !== 200 && response.status !== 409) {
                console.log("Looks like there was a problem. Status Code: " +
                    response.status);
                return;
            }
            if (response.status === 200) {
                const res = await response.json();
                ret = res.data.used;
            }
            return ret;

        },

        /**
         * Solicita al servicio correspondiente actualizar un registro MDSTAGE
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function (oEvent) {
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
                var osincubator = this.getView().getModel("OSINCUBATOR");
                var util = this.getView().getModel("util");
                var that = this;
                var serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({

                        "incubator_id": osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/incubator_id"),
                        "name": osincubator.getProperty("/name/value"),
                        "code": osincubator.getProperty("/code/value"),
                        "description": osincubator.getProperty("/description/value"),
                        "order": osincubator.getProperty("/order/value"),
                        "capacity": osincubator.getProperty("/capacity/value"),
                        "sunday": osincubator.getProperty("/sunday/value") == true ? 1 : 0,
                        "monday": osincubator.getProperty("/monday/value") == true ? 1 : 0,
                        "tuesday": osincubator.getProperty("/tuesday/value") == true ? 1 : 0,
                        "wednesday": osincubator.getProperty("/wednesday/value") == true ? 1 : 0,
                        "thursday": osincubator.getProperty("/thursday/value") == true ? 1 : 0,
                        "friday": osincubator.getProperty("/friday/value") == true ? 1 : 0,
                        "saturday": osincubator.getProperty("/saturday/value") == true ? 1 : 0,
                        "available": osincubator.getProperty("/available/value")
                    }),
                    url: serviceUrl + "/incubator/",
                    dataType: "json",
                    async: true,
                    success: function (data) {

                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("osIncubator", {}, true /*no history*/ );

                    },
                    error: function (request, status, error) {
                        that.onToast("Error de comunicación");
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
             * @type {JSONModel} OSINCUBATORPLANT         Referencia al modelo "OSINCUBATORPLANT"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var osincubator = this.getView().getModel("OSINCUBATOR"),
                flag = false;

            if (osincubator.getProperty("/name/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (osincubator.getProperty("/code/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/code")) {
                flag = true;
            }

            if (osincubator.getProperty("/description/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/description")) {
                flag = true;
            }

            if (osincubator.getProperty("/order/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/order")) {
                flag = true;
            }

            if (osincubator.getProperty("/capacity/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/capacity")) {
                flag = true;
            }

            if (osincubator.getProperty("/sunday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/sunday")) {
                flag = true;
            }
            if (osincubator.getProperty("/monday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/monday")) {
                flag = true;
            }
            if (osincubator.getProperty("/tuesday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/tuesday")) {
                flag = true;
            }
            if (osincubator.getProperty("/wednesday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/wednesday")) {
                flag = true;
            }
            if (osincubator.getProperty("/thursday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/thursday")) {
                flag = true;
            }
            if (osincubator.getProperty("friday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/friday")) {
                flag = true;
            }
            if (osincubator.getProperty("/saturday/value") !== osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/saturday")) {
                flag = true;
            }

            if (!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: function (oEvent) {
            let input = oEvent.getSource(),
                nwCode = input.getValue();
            // input.setValue(input.getValue().trim());
            let osincubator = this.getView().getModel("OSINCUBATOR");
            let excepcion = osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/name");

            if (nwCode.length > 45) {
                osincubator.setProperty("/name/state", "Error");
                osincubator.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                osincubator.setProperty("/name/ok", false);
            } else {
                this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");
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

            let osincubator = this.getView().getModel("OSINCUBATOR");
            let excepcion = osincubator.getProperty(osincubator.getProperty("/selectedRecordPath/") + "/code");

            if (nwCode.length > 20) {
                osincubator.setProperty("/code/state", "Error");
                osincubator.setProperty("/code/stateText", "Excede el limite de caracteres permitido (20)");
                osincubator.setProperty("/code/ok", false);
            } else {
                this.checkChange(input.getValue().toString(), excepcion.toString(), "/code", "changeCode");
            }
        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function (name, excepcion, field, funct) {
            let util = this.getModel("util");
            let mdModel = this.getModel("OSINCUBATOR");
            //let AJA = this.getModel("MDBREED").getProperty("/records")
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

                if (name === "" || name === null || name === undefined) {
                    mdModel.setProperty(field + "/state", "Error");
                    mdModel.setProperty(field + "/stateText", "El campo no puede estar vacio");
                    mdModel.setProperty(field + "/ok", true);
                } else {
                    if (found === undefined) {
                        mdModel.setProperty(field + "/state", "Success");
                        mdModel.setProperty(field + "/stateText", "");
                        mdModel.setProperty(field + "/ok", true);
                    } else {
                        mdModel.setProperty(field + "/state", "Error");
                        mdModel.setProperty(field + "/stateText", (funct === "changeCode") ? "código ya existente" : "nombre ya existente");
                        mdModel.setProperty(field + "/ok", false);
                    }
                }
            }
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeDescription: function (oEvent) {
            let input = oEvent.getSource();
            let nwDescription = input.getValue();
            let osincubator = this.getView().getModel("OSINCUBATOR");

            if (nwDescription.length > 100) {
                osincubator.setProperty("/description/state", "Error");
                osincubator.setProperty("/description/stateText", "Excede el limite de caracteres permitido (100)");
                osincubator.setProperty("/description/ok", false);
            } else {
                if (nwDescription !== null && nwDescription !== "" && nwDescription !== undefined) {
                    osincubator.setProperty("/description/state", "None");
                    osincubator.setProperty("/description/stateText", "");
                    osincubator.setProperty("/description/ok", true);
                }
            }
        },
    });
});