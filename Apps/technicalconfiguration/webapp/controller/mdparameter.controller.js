sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Sorter",
    "sap/ui/model/Filter",
    "sap/m/Dialog",
    "sap/m/Button"
], function (BaseController, JSONModel, Sorter, Filter, Dialog, Button) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.mdparameter", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function () {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("mdparameter").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("mdparameter_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("mdparameter_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function (oEvent) {

            const util = this.getModel("util");
            const mdparameter = this.getModel("MDPARAMETER");
            //dependiendo del dispositivo, establece la propiedad "phone"
            util.setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            //establece MDPARAMETER como la entidad seleccionada
            util.setProperty("/selectedEntity/", "mdparameter");

            util.setProperty("/busy", true);

            //obtiene los registros de MDPARAMETER
            this.getParametersData()
                .then(records => {
                    mdparameter.setProperty("/records/", records.data);
                    util.setProperty("/busy", false);
                })
                .catch(err => {
                    console.log(err);
                });
        },

        /**
         * Obtiene todos los registros de MDPARAMETER
         */
        getParametersData: function () {
            const util = this.getModel("util");
            const mdparameter = this.getModel("MDPARAMETER");
            var serviceUrl = util.getProperty("/serviceUrl");
            const url = serviceUrl + "/parameter/";
            const method = "GET";
            const data = {};

            return new Promise((resolve, reject) => {
                function getParameters(res) {
                    resolve(res);
                }

                function error(err) {
                    reject(err);
                }

                this.sendRequest.call(this, url, method, data, getParameters, error, error);
            });
        },
        /**
         * llamada para hacer la peticion 
         * @param {String} url ruta del servicio    
         * @param {String} method tipo de solicitud
         * @param {JSON} data declaracion de un json
         * @param {Function} successFunc funcion success de la promesa
         * @param {Function} srvErrorFunc funcion error de la promesa
         * @param {Function} connErrorFunc funcion error de la promesa
         */
        sendRequest: function (url, method, data, successFunc, srvErrorFunc, connErrorFunc) {
            const util = this.getModel("util");
            const $settings = {
                url: url,
                method: method,
                data: JSON.stringify(data),
                contentType: "application/json",
                error: err => {
                    util.setProperty("/connectionError/status", err.status);
                    util.setProperty("/connectionError/message", err.statusText);
                    this.onConnectionError();
                    if (connErrorFunc) connErrorFunc(err);

                },
                success: res => {
                    if (res.statusCode !== 200) {
                        util.setProperty("/serviceError/status", res.statusCode);
                        util.setProperty("/serviceError/message", res.msg);
                        this.onServiceError();
                        if (srvErrorFunc) srvErrorFunc(res);
                    } else {
                        successFunc(res);
                    }
                }
            };
            $.ajax($settings);
        },
        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: function (oEvent) {
            var util = this.getView().getModel("util");
            var create = true;
            this.loadProcessForC();
            this.loadMeasure(create);

            this._resetRecordValues();
            this._editRecordValues(true);
            this._editRecordRequired(true);
            util.setProperty("/busy/", false);

        },
        /**
         * Carga los Procesos
         * @param {Boolean} create si es true, asigna el id del proceso al modelo "mdparameter"
         */
        loadProcess: function (create) {
            var util = this.getView().getModel("util"),
                mdprocess = this.getView().getModel("MDPROCESS"),
                mdparameter = this.getModel("MDPARAMETER");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/process/",
                method: "GET",
                success: function (res) {
                    mdprocess.setProperty("/records", res.data);
                    if (create) {
                        mdparameter.setProperty("/process_id", res.data[0].process_id);
                    }
                },
                error: function (err) {
                    console.log(err);
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);

                }
            };


            //borra los registros MDPROCESS que estén almacenados actualmente
            mdprocess.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
            console.log("listo");
        },
        /**
         *Carga los valores de medidas
         */
        loadMeasure: function (create) {
            var mdmeasure = this.getView().getModel("MDMEASURE"),
                util = this.getView().getModel("util"),
                mdparameter = this.getModel("MDPARAMETER");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/measure/",
                method: "GET",
                success: function (res) {
                    mdmeasure.setProperty("/records", res.data);
                    if (create) mdparameter.setProperty("/measure_id/value", "");
                },
                error: function (err) {
                    console.log(err);
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);

                }
            };
            //borra los registros MDPROCESS que estén almacenados actualmente
            mdmeasure.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);

        },
        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function () {
            /**
             * @type {JSONModel} MDPARAMETER Referencia al modelo "MDPARAMETER"
             */
            var mdparameter = this.getView().getModel("MDPARAMETER");

            mdparameter.setProperty("/name/editable", true);
            mdparameter.setProperty("/name/value", "");
            mdparameter.setProperty("/name/state", "None");
            mdparameter.setProperty("/name/stateText", "");

            mdparameter.setProperty("/process_id/value", "");
            mdparameter.setProperty("/process_id/state", "None");
            mdparameter.setProperty("/process_id/stateText", "");

            mdparameter.setProperty("/measure_id/value", "");
            mdparameter.setProperty("/measure_id/state", "None");
            mdparameter.setProperty("/measure_id/stateText", "");


            mdparameter.setProperty("/type/value", "");
            mdparameter.setProperty("/type/state", "None");
            mdparameter.setProperty("/type/stateText", "");

            mdparameter.setProperty("/description/value", "");
            mdparameter.setProperty("/description/state", "None");
            mdparameter.setProperty("/description/stateText", "");

            mdparameter.setProperty("/name/ok", false);

        },
        /**
         * Habilita/deshabilita la edición de los datos de un registro MDPARAMETER
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function (edit) {

            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/name/editable", edit);
            mdparameter.setProperty("/description/editable", edit);
            mdparameter.setProperty("/process_id/editable", edit);
            mdparameter.setProperty("/measure_id/editable", edit);
            mdparameter.setProperty("/type/editable", edit);

        },
        /**
         * Se define un campo como obligatorio o no, de un registro MDPARAMETER
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function (edit) {
            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/name/required", edit);
            mdparameter.setProperty("/description/required", edit);
            mdparameter.setProperty("/process_id/required", edit);
            mdparameter.setProperty("/measure_id/required", edit);
            mdparameter.setProperty("/type/required", edit);

        },
        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function (oEvent) {
            this.resetSearch();
            this.getRouter().navTo("mdparameter_Create", {}, false /*create history*/ );
        },
        /**
         * Cancela la creación de un registro MDPARAMETER, y regresa a la vista principal
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
            var util = this.getView().getModel("util");

            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/ );
        },
        /**
         * Solicita al servicio correspondiente crear un registro MDPARAMETER
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function (oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                /**
                 * @type {JSONModel} MDPARAMETER   Referencia al modelo "MDPARAMETER"
                 * @type {JSONModel} util    Referencia al modelo "util"
                 * @type {Controller} that    Referencia a este controlador
                 * @type {Object} json        Objeto a enviar en la solicitud
                 * @type {Object} settings    Opciones de la llamada a la función ajax
                 */
                var that = this;
                var util = this.getView().getModel("util");
                var mdparameter = this.getView().getModel("MDPARAMETER");
                var serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "name": mdparameter.getProperty("/name/value"),
                        "description": mdparameter.getProperty("/description/value"),
                        "type": mdparameter.getProperty("/type/value"),
                        "measure_id": mdparameter.getProperty("/measure_id/value"),
                        "process_id": mdparameter.getProperty("/process_id/value")
                    }),
                    url: serviceUrl + "/parameter/",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("mdparameter", {}, true /*no history*/ );

                    },
                    error: function (error) {
                        that.onToast("Error: " + error.responseText);
                        console.log("Read failed ");
                    }
                });

            }
        },
        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de proceso en el formulario.
         */
        updateProcessModel: function () {
            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/process_id/value", this.getView().byId("parameter_nameProcess_model").getSelectedKey());
            mdparameter.setProperty("/process_id/state", "None");
            mdparameter.setProperty("/process_id/stateText", "");
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de Medida en el formulario.
         */
        updateMeasureModel: function () {
            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/measure_id/value", this.getView().byId("parameter_measure_model").getSelectedKey());
            mdparameter.setProperty("/measure_id/state", "None");
            mdparameter.setProperty("/measure_id/stateText", "");

        },
        /**
         * Valida la correctitud de los datos existentes en el formulario del registro
         * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
         */
        _validRecord: function () {
            /**
             * @type {JSONModel} MDPARAMETER Referencia al modelo "MDPARAMETER"
             * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
             */
            var mdparameter = this.getView().getModel("MDPARAMETER"),
                flag = true,
                Without_Num = /^[a-zA-Z\s]*$/;

            if (mdparameter.getProperty("/name/value") === "") {
                flag = false;
                mdparameter.setProperty("/name/state", "Error");
                mdparameter.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (!Without_Num.test(mdparameter.getProperty("/order_/value"))) {
                flag = false;
                mdparameter.setProperty("/name/state", "Error");
                mdparameter.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD.WN"));
            } else {
                mdparameter.setProperty("/name/state", "None");
                mdparameter.setProperty("/name/stateText", "");
            }


            if (mdparameter.getProperty("/description/value") === "") {
                flag = false;
                mdparameter.setProperty("/description/state", "Error");
                mdparameter.setProperty("/description/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                mdparameter.setProperty("/description/state", "None");
                mdparameter.setProperty("/description/stateText", "");
            }


            if (mdparameter.getProperty("/process_id/value") === "") {
                flag = false;
                mdparameter.setProperty("/process_id/state", "Error");
                mdparameter.setProperty("/process_id/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                mdparameter.setProperty("/process_id/state", "None");
                mdparameter.setProperty("/process_id/stateText", "");
            }

            if (mdparameter.getProperty("/measure_id/value") === "") {
                flag = false;
                mdparameter.setProperty("/measure_id/state", "Error");
                mdparameter.setProperty("/measure_id/stateText", this.getI18n().getText("enter.FIELD"));
            } else {
                mdparameter.setProperty("/measure_id/state", "None");
                mdparameter.setProperty("/measure_id/stateText", "");
            }

            return flag;
        },
        /**
         * Visualiza los detalles de un registro MDPARAMETER
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onViewParameterRecord: function (oEvent) {
            this._resetRecordValues();
            var mdparameter = this.getView().getModel("MDPARAMETER");
            var mdprocess = this.getView().getModel("MDPROCESS");
            var create = false;
            this.loadProcess(create);
            this.loadMeasure(create);
            mdparameter.setProperty("/save/", false);
            mdparameter.setProperty("/cancel/", false);
            mdparameter.setProperty("/selectedRecordPath/", oEvent.getSource().getBindingContext("MDPARAMETER"));
            mdparameter.setProperty("/parameter_id/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().parameter_id);
            mdparameter.setProperty("/name/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().name);
            mdparameter.setProperty("/name/excepcion", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().name);
            mdparameter.setProperty("/description/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().description);
            mdparameter.setProperty("/type/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().type);
            mdparameter.setProperty("/measure_id/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().measure_id);
            mdparameter.setProperty("/process_id/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().process_id);
            mdprocess.setProperty("/process_id/value", oEvent.getSource().getBindingContext("MDPARAMETER").getObject().process_id);
            mdparameter.setProperty("/name/ok", true);
            this.resetSearch();
            this.getRouter().navTo("mdparameter_Record", {}, false /*create history*/ );
        },
        /**
         *   Carga la lista de procesos del formulario
         *
         */
        loadProcess: function () {
            var mdprocess = this.getView().getModel("MDPROCESS");
            var util = this.getView().getModel("util");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/process/",
                method: "GET",
                success: function (res) {
                    mdprocess.setProperty("/records", res.data);
                },
                error: function (err) {
                    console.log(err);
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };
            //borra los registros MDPROCESS que estén almacenados actualmente
            mdprocess.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);

        },

        /**
         *   Carga la lista de procesos del formulario
         */
        loadProcessForC: function () {
            var mdprocess = this.getView().getModel("MDPROCESS"),
                mdparameter = this.getModel("MDPARAMETER");
            var util = this.getView().getModel("util");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/process/",
                method: "GET",
                success: function (res) {
                    mdprocess.setProperty("/records", res.data);
                    mdparameter.setProperty("/process_id/value", "");
                },
                error: function (err) {
                    console.log(err);
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };

            //borra los registros MDPROCESS que estén almacenados actualmente
            mdprocess.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);

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
            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/cancel/", false);
            mdparameter.setProperty("/modify/", true);
            mdparameter.setProperty("/delete/", true);
            mdparameter.setProperty("/save/", false);
            this._editRecordValues(false);
            this._editRecordRequired(false);

        },
        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function (oEvent) {

            var mdparameter = this.getView().getModel("MDPARAMETER");
            mdparameter.setProperty("/save/", true);
            mdparameter.setProperty("/cancel/", true);
            mdparameter.setProperty("/modify/", false);
            mdparameter.setProperty("/delete/", false);
            this._editRecordRequired(true);
            this._editRecordValues(true);
        },

        /**
         * Cancela la edición de un registro MDPARAMETER
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function (oEvent) {
            /** @type {JSONModel} MDPARAMETER  Referencia al modelo MDPARAMETER */
            var mdparameter = this.getView().getModel("MDPARAMETER");

            mdparameter.setProperty("/name/value", mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/name"));
            mdparameter.setProperty("/description/value", mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/description"));
            mdparameter.setProperty("/process_id/value", mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/process_id"));
            mdparameter.setProperty("/measure_id/value", mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/measure_id"));
            mdparameter.setProperty("/type/value", mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/type"));

            this.onView();
        },
        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function () {
            this._viewOptions();
        },
        /**
         * Solicita al servicio correspondiente actualizar un registro MDPARAMETER
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function (oEvent) {
            /**
             * Si el registro que se quiere actualizar es válido y hubo algún cambio
             * con respecto a sus datos originales
             */
            if (this._validRecord() && this._recordChanged()) {
                /**
                 * @type {JSONModel} MDPARAMETER   Referencia al modelo "MDPARAMETER"
                 * @type {JSONModel} util         Referencia al modelo "util"
                 * @type {Controller} that         Referencia a este controlador
                 */
                var mdparameter = this.getView().getModel("MDPARAMETER");
                var util = this.getView().getModel("util");
                var that = this;
                var serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "parameter_id": mdparameter.getProperty("/parameter_id/value"),
                        "name": mdparameter.getProperty("/name/value"),
                        "description": mdparameter.getProperty("/description/value"),
                        "type": mdparameter.getProperty("/type/value"),
                        "measure_id": mdparameter.getProperty("/measure_id/value"),
                        "process_id": mdparameter.getProperty("/process_id/value")
                    }),
                    url: serviceUrl + "/parameter/",
                    dataType: "json",
                    async: true,
                    success: function (data) {

                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("mdparameter", {}, true /*no history*/ );

                    },
                    error: function (request, status, error) {
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
        _recordChanged: function () {
            /**
             * @type {JSONModel} MDPARAMETER         Referencia al modelo "MDPARAMETER"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var mdparameter = this.getView().getModel("MDPARAMETER"),
                mdprocess = this.getView().getModel("MDPROCESS"),
                flag = false;

            if (mdparameter.getProperty("/name/value") !== mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (mdparameter.getProperty("/description/value") !== mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/description")) {
                flag = true;
            }


            if (mdparameter.getProperty("/type/value") !== mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/type")) {
                flag = true;
            }

            if (mdparameter.getProperty("/measure_id/value") !== mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/measure_id")) {
                flag = true;
            }

            if (mdparameter.getProperty("/process_id/value") !== mdparameter.getProperty(mdparameter.getProperty("/selectedRecordPath/") + "/process_id")) {
                flag = true;
            }


            if (!flag) this.onToast("No se detectaron cambios");

            return flag;
        },


        /**
         * Inicializar los buscadores. 
         *
         */
        resetSearch: function () {
            this.getView().byId("parameterSearchField").setValue("");
            this.onParameterSearch();
        },

        /**
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onParameterSearch: function (oEvent) {

            /**
             * Filtra por nombre y codigo 
             * @param {Event} oEvent       Evento que llamó esta función
             * @type {Array}  oFilter      Variable para guardar el resultado de la busqueda
             * @returns {Array} Se envia a la vista el resultado obtenido. 
             */

            let sQuery = this.getView().byId("parameterSearchField").getValue().toString(),
                binding = this.getView().byId("parameterTable").getBinding("items");

            if (sQuery) {
                let name = new Filter("name", sap.ui.model.FilterOperator.Contains, sQuery),
                    description = new Filter("description", sap.ui.model.FilterOperator.Contains, sQuery),
                    name_process = new Filter("name_process", sap.ui.model.FilterOperator.Contains, sQuery);

                var oFilter = new sap.ui.model.Filter({
                    aFilters: [name, description, name_process],
                    and: false
                });
            }

            binding.filter(oFilter);

        },

        /**
         * Levanta el Dialogo que muestra la confirmacion del Eliminar un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function (oEvent) {
            var oBundle = this.getView().getModel("i18n").getResourceBundle();
            var confirmation = oBundle.getText("confirmation");
            var that = this,
                util = this.getView().getModel("util"),
                mdparameter = this.getView().getModel("MDPARAMETER"),
                parameter_id = mdparameter.getProperty("/parameter_id/value");

            let cond = await this.onVerifyIsUsed(parameter_id);

            if (cond) {
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new sap.m.Text({
                        text: "No se puede eliminar el parámetro, porque está siendo utilizado."
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
                        text: "¿Desea eliminar este parámetro?"
                    }),

                    beginButton: new Button({
                        text: "Si",
                        press: function () {
                            util.setProperty("/busy/", true);
                            var serviceUrl = util.getProperty("/serviceUrl");
                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "parameter_id": parameter_id
                                }),
                                url: serviceUrl + "/parameter/",
                                dataType: "json",
                                async: true,
                                success: function (data) {

                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("mdparameter", {}, true);
                                    dialog.close();
                                },
                                error: function (request, status, error) {
                                    that.onToast("Error de comunicación");
                                    console.log("Read failed");
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
         * Verifica si el proceso esta en uso 
         * @param {JSON} parameter_id
         */
        onVerifyIsUsed: async function (parameter_id) {
            let ret;
            const response = await fetch("/parameter/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    parameter_id: parameter_id
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
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: function (oEvent) {
            let input = oEvent.getSource();
            //input.setValue(input.getValue().trim());
            let model = this.getModel("MDPARAMETER");

            let excepcion = model.getProperty("/name/excepcion");
            this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");
        },

        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeDescription: function (oEvent) {
            let input = oEvent.getSource().getValue();
            let model = this.getModel("MDPARAMETER");

            if (input.length > 100) {
                model.setProperty("/description/state", "Error");
                model.setProperty("/description/stateText", "Excede el limite de caracteres permitido (100)");
                model.setProperty("/name/ok", false);
            } else if (input !== "") {
                model.setProperty("/description/state", "None");
                model.setProperty("/description/stateText", "");
            } else {
                model.setProperty("/description/state", "Error");
                model.setProperty("/description/stateText", this.getI18n().getText("enter.FIELD"));
            }

        },

        /**
         * verifica los campos esten correctamente lleno para habilitar boton de guardar. 
         *
         * @returns true habilita el boton, false deshabilita
         */
        enableCreate: function () {

            var mdparameter = this.getView().getModel("MDPARAMETER"),
                flag;
            if (mdparameter.getProperty("/name/state") === "Error" || mdparameter.getProperty("/description/state") === "Error" ||
                mdparameter.getProperty("/process_id/state") === "Error" || mdparameter.getProperty("/measure_id/state") === "Error" ||
                mdparameter.getProperty("/type/state") === "Error") {

                flag = false;
            } else {
                flag = true;
            }
            return flag;
        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} excepcion excepcion del modelo 
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function (name, excepcion, field, funct) {
            let mdModel = this.getModel("MDPARAMETER");
            if (name == "" || name === null) {
                mdModel.setProperty(field + "/state", "None");
                mdModel.setProperty(field + "/stateText", "");
                mdModel.setProperty(field + "/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found;

                found = await registers.find(element => ((element.name).toLowerCase() === name.toLowerCase() && element.name !== excepcion));


                if (found === undefined) {
                    mdModel.setProperty(field + "/state", "Success");
                    mdModel.setProperty(field + "/stateText", "");
                    mdModel.setProperty(field + "/ok", true);
                } else {
                    mdModel.setProperty(field + "/state", "Error");
                    mdModel.setProperty(field + "/stateText", "nombre ya existente");
                    mdModel.setProperty(field + "/ok", false);
                    mdModel.setProperty("name/ok", false);
                }
            }
        }
    });
});