sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/Text",
    "sap/ui/model/Filter"
], function(BaseController, JSONModel,Dialog,Button, Text, Filter) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.oscenter", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function() {
            //ruta para la vista principal de núcleos
            this.getOwnerComponent().getRouter().getRoute("oscenter").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de creación de un núcleo
            this.getOwnerComponent().getRouter().getRoute("oscenter_Create").attachPatternMatched(this._onCreateMatched, this);
            //ruta para la vista de detalles de un núcleo
            this.getOwnerComponent().getRouter().getRoute("oscenter_Record").attachPatternMatched(this._onRecordMatched, this);
        },
        
        /**
         * Funcion para detectar el cambio de iconos en el tabbar
         *
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onSelectChangedTab: function(oEvent){
            let oscenter = this.getView().getModel("OSCENTER");

            this.getView().byId("partnershipSearchField").setValue(""); 
            this.getView().byId("partnershipTable").getBinding("items").filter(null)

            this.getView().byId("farmsearchid").setValue(""); 
            this.getView().byId("farmTable").getBinding("items").filter(null)

            this.getView().byId("searchCenterId").setValue(""); 
            this.getView().byId("centerTable").getBinding("items").filter(null)
            let key = (oEvent.getParameters().selectedKey).split("--");
            if(key[1] !== "centerFilter"){
                oscenter.setProperty("/new", false);
            }else{
                oscenter.setProperty("/new", true);
            }
        },

        /**
		 * Coincidencia de ruta para acceder a la vista principal
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        _onRouteMatched: function(oEvent) {
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
                osfarm = this.getView().getModel("OSFARM"),
                oscenter = this.getView().getModel("OSCENTER");

            ospartnership.setProperty("/itemType", "Inactive");
            osfarm.setProperty("/itemType", "Inactive");
            oscenter.setProperty("/itemType", "DetailAndActive");

            //dependiendo del dispositivo, establece la propiedad "phone"
            util.setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            ospartnership.setProperty("/settings/tableMode", "SingleSelect");
            osfarm.setProperty("/settings/tableMode", "SingleSelect");
            oscenter.setProperty("/settings/tableMode", "None");

            //si la entidad seleccionada antes de acceder a esta vista es diferente a CENTER
            if (util.getProperty("/selectedEntity") !== "oscenter") {

                //establece CENTER como la entidad seleccionada
                util.setProperty("/selectedEntity", "oscenter");

                //establece el tab de la tabla PARTNERSHIP como el tab seleccionado
                this.getView().byId("tabBar").setSelectedKey(this.getView().getId() + "--" + "partnershipFilter");

                //limpio selectedRecord
                ospartnership.setProperty("/selectedRecord", "");
                osfarm.setProperty("/selectedRecord", "");
                //borra cualquier selección que se haya hecho en la tabla PARTNERSHIP
                this.getView().byId("partnershipTable").removeSelections(true);

                //borra cualquier selección que se haya hecho en la tabla BROILERSFARM
                this.getView().byId("farmTable").removeSelections(true);

                //establece que no hay ningún registro PARTNERSHIP seleccionado
                ospartnership.setProperty("/selectedRecordPath/", "");

                //establece que no hay ningún registro BROILERSFARM seleccionado
                osfarm.setProperty("/selectedRecordPath/", "");

                osfarm.setProperty("/records/", []);

                oscenter.setProperty("/records/", []);

                //deshabilita el tab de la tabla de registros BROILERSFARM
                osfarm.setProperty("/settings/enabledTab", false);

                //deshabilita el tab de la tabla de registros CENTER
                oscenter.setProperty("/settings/enabledTab", false);

                //deshabilita la opción de crear un registro CENTER
                oscenter.setProperty("/new", false);

                //obtiene los registros de PARTNERSHIP
                sap.ui.controller("technicalConfiguration.controller.ospartnership").onRead(that, util, ospartnership);

            } else if (ospartnership.getProperty("/selectedRecordPath/") !== "" &&
				osfarm.getProperty("/selectedRecordPath/") !== "") {

                //habilita el tab de la tabla de registros BROILERSFARM
                osfarm.setProperty("/settings/enabledTab", true);

                //habilita el tab de la tabla de registros CENTER
                oscenter.setProperty("/settings/enabledTab", true);

                //habilita la opción de crear un registro CENTER
                oscenter.setProperty("/new", true);

                //obtiene los registros de CENTER
                this.onRead(that, util, ospartnership, osfarm, oscenter);
            }
        },

        /**
		 * Regresa a la vista principal de la entidad seleccionada actualmente
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onNavBack: function(oEvent) {
            /** @type {JSONModel} util Referencia al modelo "OS" */
            var util = this.getView().getModel("util");

            this._resetRecordValues();
            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, true);
        },

        /**
		 * Selecciona un registro PARTNERSHIP y habilita la tabla de registros BROILERSFARM
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onSelectPartnershipRecord: function(oEvent) {
            /**
			 * @type {Controller} that          Referencia a este controlador
			 * @type {JSONModel} dummy          Referencia al modelo "dummy"
			 * @type {JSONModel} PARTNERSHIP  Referencia al modelo "PARTNERSHIP"
			 * @type {JSONModel} BROILERSFARM Referencia al modelo "BROILERSFARM"
			 * @type {JSONModel} CENTER       Referencia al modelo "CENTER"
			 */
            
            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                osfarm = this.getView().getModel("OSFARM"),
                oscenter = this.getView().getModel("OSCENTER");

            //guarda la ruta del registro PARTNERSHIP que fue seleccionado
            ospartnership.setProperty("/selectedRecordPath/", oEvent.getSource()["_aSelectedPaths"][0]);
            ospartnership.setProperty("/selectedRecord/", ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/")));

            osfarm.setProperty("/selectedRecordPath/", "");
            osfarm.setProperty("/selectedRecord/", {});

            //habilita el tab de la tabla de registros BROILERSFARM
            osfarm.setProperty("/settings/enabledTab", true);

            //deshabilita el tab de la tabla de registros CENTER
            oscenter.setProperty("/settings/enabledTab", false);

            //deshabilita la opción de crear un registro CENTER
            oscenter.setProperty("/new", false);

            //establece el tab de la tabla BROILERSFARM como el tab seleccionado
            this.getView().byId("tabBar").setSelectedKey(this.getView().getId() + "--" + "broilersFarmFilter");

            //borra cualquier selección que se haya hecho en la tabla BROILERSFARM
            this.getView().byId("farmTable").removeSelections(true);

            //obtiene los registros de BROILERSFARM
            sap.ui.controller("technicalConfiguration.controller.osfarm").onRead(that, util, ospartnership, osfarm);
        },

        /**
		 * Selecciona un registro BROILERSFARM y habilita la tabla de registros CENTER
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onSelectFarmRecord: function(oEvent) {
            /**
			 * @type {Controller} that          Referencia a este controlador
			 * @type {JSONModel} dummy          Referencia al modelo "dummy"
			 * @type {JSONModel} PARTNERSHIP  Referencia al modelo "PARTNERSHIP"
			 * @type {JSONModel} BROILERSFARM Referencia al modelo "BROILERSFARM"
			 * @type {JSONModel} CENTER       Referencia al modelo "CENTER"
			 */
            var that = this,
                util = this.getView().getModel("util"),
                ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                osfarm = this.getView().getModel("OSFARM"),
                oscenter = this.getView().getModel("OSCENTER");

            //guarda la ruta del registro BROILERSFARM que fue seleccionado
            osfarm.setProperty("/selectedRecordPath/", oEvent.getSource()["_aSelectedPaths"][0]);

            osfarm.setProperty("/selectedRecord/", osfarm.getProperty(osfarm.getProperty("/selectedRecordPath/")));

            //habilita el tab de la tabla de registros CENTER
            oscenter.setProperty("/settings/enabledTab", true);

            //habilita la opción de crear un registro CENTER
            oscenter.setProperty("/new", true);

            //establece el tab de la tabla CENTER como el tab seleccionado
            this.getView().byId("tabBar").setSelectedKey(this.getView().getId() + "--" + "centerFilter");

            //obtiene los registros de CENTER
            this.onRead(that, util, ospartnership, osfarm, oscenter);
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
         * Este evento se activa cuando el usuario cambia el valor del campo de búsqueda. se actualiza el binding de la lista
         * @param {Event} oEvent Evento que llamó esta función
         */
        onFarmSearch: function(oEvent){
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("farmTable").getBinding("items");
            if (sQuery && sQuery.length > 0) {
                /** @type {Object} filter1 Primer filtro de la búsqueda */
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
        onBroilersCenterSearch: function(oEvent) {
            var aFilters = [],
                sQuery = oEvent.getSource().getValue(),
                binding = this.getView().byId("centerTable").getBinding("items");

            if (sQuery && sQuery.length > 0) {
                /** @type {Object} filter1 Primer filtro de la búsqueda */
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
		 * Obtiene todos los registros de BROILERSFARM, dado un cliente y una sociedad
		 * @param  {Controller} that          Referencia al controlador que llama esta función
		 * @param  {JSONModel} dummy          Referencia al modelo "dummy"
		 * @param  {JSONModel} PARTNERSHIP  Referencia al modelo "PARTNERSHIP"
		 * @param  {JSONModel} BROILERSFARM Referencia al modelo "BROILERSFARM"
		 * @param  {JSONModel} CENTER       Referencia al modelo "CENTER"
		 */
        onRead: function(that, util, ospartnership, osfarm, oscenter) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var serviceUrl = util.getProperty("/serviceUrl");
            var farm_id = osfarm.getProperty(osfarm.getProperty("/selectedRecordPath/") + "/farm_id");
            var settings = {
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    "farm_id": farm_id,
                }),
                url: serviceUrl+"/center/findCenterByFarm",
                dataType: "json",
                async: true,
                success: function(res) {
                    util.setProperty("/busy/", false);
                    res.data.forEach(element => {
                        element.old = element.order;
                    });
                    oscenter.setProperty("/records/", res.data);
                },
                error: function(err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                    //that.onConnectionError();
                }
            };
            util.setProperty("/busy/", true);
            //borra los registros CENTER que estén almacenados actualmente
            oscenter.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
        },

        /**
		 * Navega a la vista para crear un nuevo registro
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onNewRecord: function(oEvent) {
            this.getRouter().navTo("oscenter_Create", {}, true);
        },

        /**
		 * Coincidencia de ruta para acceder a la creación de un registro
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        _onCreateMatched: function(oEvent) {
            //resetea y habilita los campos del formulario para su edición
            this._resetRecordValues();
            this._editRecordValues(true);
            // this.getView().byId("searchCenterId").setValue(""); 
            // this.getView().byId("centerTable").getBinding("items").filter(null)
        },

        /**
		 * Resetea todos los valores existentes en el formulario del registro
		 */
        _resetRecordValues: function() {
            /** @type {JSONModel} CENTER Referencia al modelo "CENTER" */
            var oscenter = this.getView().getModel("OSCENTER");

            oscenter.setProperty("/code/value", "");
            oscenter.setProperty("/code/state", "None");
            oscenter.setProperty("/code/stateText", "");

            oscenter.setProperty("/name/value", "");
            oscenter.setProperty("/name/state", "None");
            oscenter.setProperty("/name/stateText", "");

            oscenter.setProperty("/disable/value", false);
        },

        /**
		 * Habilita/deshabilita la edición de los datos de un registro
		 * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
		 */
        _editRecordValues: function(edit,f) {
            /** @type {JSONModel} CENTER Referencia al modelo "CENTER" */
            var oscenter = this.getView().getModel("OSCENTER");

            if(f==="cancelEdit"){

                oscenter.setProperty("/disable/value",oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/")+"/disable"));

             }

            oscenter.setProperty("/code/editable", edit);
            oscenter.setProperty("/code/required", edit);

            oscenter.setProperty("/name/editable", edit);
            oscenter.setProperty("/name/required", edit);

            oscenter.setProperty("/disable/editable", edit);
        },

        /**
		 * Habilita/deshabilita la edición de los datos de un registro
		 * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
		 */
        _editRecordValues2: function(edit) {
            /** @type {JSONModel} CENTER Referencia al modelo "CENTER" */
            var oscenter = this.getView().getModel("OSCENTER");

            // oscenter.setProperty("/code/editable", edit);
            // oscenter.setProperty("/code/required", edit);

            // oscenter.setProperty("/name/editable", edit);
            // oscenter.setProperty("/name/required", edit);

            oscenter.setProperty("/disable/editable", edit);
        },

        /**
		 * Valida la correctitud de los datos existentes en el formulario del registro
		 * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
		 */
        _validRecord: function() {
            /**
			 * @type {JSONModel} CENTER Referencia al modelo "CENTER"
			 * @type {Boolean} flag             "true" si los datos son válidos, "false" si no lo son
			 */
            var oscenter = this.getView().getModel("OSCENTER"),
                flag = true;

            if (oscenter.getProperty("/code/value") === "") {
                flag = false;
                oscenter.setProperty("/code/state", "Error");
                oscenter.setProperty("/code/stateText", "el campo código no puede estar vacío");
            } else {
                oscenter.setProperty("/code/state", "None");
                oscenter.setProperty("/code/stateText", "");
            }

            if (oscenter.getProperty("/name/value") === "") {
                flag = false;
                oscenter.setProperty("/name/state", "Error");
                oscenter.setProperty("/name/stateText", "el campo nombre no puede estar vacío");
            } else {
                oscenter.setProperty("/name/state", "None");
                oscenter.setProperty("/name/stateText", "");
            }

            return flag;
        },

        /**
		 * Valida la correctitud de los datos existentes en el formulario del registro
		 * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
		 */
        _validRecord2: function() {
            /**
			 * @type {JSONModel} CENTER Referencia al modelo "CENTER"
			 * @type {Boolean} flag             "true" si los datos son válidos, "false" si no lo son
			 */
            var oscenter = this.getView().getModel("OSCENTER"),
                flag = true;

            if (oscenter.getProperty("/code/value") === "") {
                flag = false;
                oscenter.setProperty("/code/state", "Error");
                oscenter.setProperty("/code/stateText", "el campo código no puede estar vacío");
            }else if(oscenter.getProperty("/code/state") == "Error"){
                flag = false;
            } else {
                oscenter.setProperty("/code/state", "None");
                oscenter.setProperty("/code/stateText", "");
            }

            if (oscenter.getProperty("/name/value") === "") {
                flag = false;
                oscenter.setProperty("/name/state", "Error");
                oscenter.setProperty("/name/stateText", "el campo nombre no puede estar vacío");
            }else if(oscenter.getProperty("/name/state") == "Error"){
                flag = false;
            } else {
                oscenter.setProperty("/name/state", "None");
                oscenter.setProperty("/name/stateText", "");
            }

            return flag;
        },


        /**
		 * Solicita al servicio correspondiente crear un registro CENTER,
		 * dado un cliente, una sociedad y una granja
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onCreate: function(oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                /**
				 * @type {JSONModel} CENTER Referencia al modelo "CENTER"
				 * @type {JSONModel} dummy    Referencia al modelo "dummy"
				 * @type {Controller} that    Referencia a este controlador
				 * @type {Object} json        Objeto a enviar en la solicitud
				 * @type {Object} settings    Opciones de la llamada a la función ajax
				 */
                var ospartnership = this.getView().getModel("OSPARTNERSHIP"),
                    osfarm = this.getView().getModel("OSFARM"),
                    oscenter = this.getView().getModel("OSCENTER"),
                    util = this.getView().getModel("util"),
                    that = this,
                    serviceUrl = util.getProperty("/serviceUrl"),
                    json = {
						
                        "partnership_id": ospartnership.getProperty(ospartnership.getProperty("/selectedRecordPath/") + "/partnership_id"),
                        "farm_id": osfarm.getProperty(osfarm.getProperty("/selectedRecordPath/") + "/farm_id"),
                        "code": oscenter.getProperty("/code/value"),
                        "name": oscenter.getProperty("/name/value"),
                        "os_disable": oscenter.getProperty("/disable/value")
                    },
                    settings = {
                        async: true,
                        url: serviceUrl+"/center",
                        method: "POST",
                        data: JSON.stringify(json),
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function(res) {

                            util.setProperty("/busy/", false);
                            that._resetRecordValues();
                            that.onToast(that.getI18n().getText("OS.recordCreated"));
                            that.getRouter().navTo("oscenter", {}, true /*no history*/ );

                        },
                        error: function(err) {
                            that.onToast("Error: " + err);
                            console.log("Read failed ");
                        }
                    };
                util.setProperty("/busy/", true);
                //realiza la llamada ajax
                $.ajax(settings);
            }
        },

        /**
		 * Coincidencia de ruta para acceder a los detalles de un registro
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        _onRecordMatched: function(oEvent) {
            //Establece las opciones disponibles al visualizar el registro
            this._viewOptions();
        },


        /**
		 * Cambia las opciones de visualización disponibles en la vista de detalles de un registro
		 */
        _viewOptions: function(f) {
            /**
			 * @type {JSONModel} util       Referencia al modelo "util"
			 * @type {JSONModel} OSCENTER Referencia al modelo "OSCENTER"
			 */
            var util = this.getView().getModel("util"),
                oscenter = this.getView().getModel("OSCENTER");

            if (util.getProperty("/selectedEntity/") === "oscenter") {
                oscenter.setProperty("/modify/", true);
                oscenter.setProperty("/delete/", true);
            } else {
                oscenter.setProperty("/modify/", false);
                oscenter.setProperty("/delete/", false);
            }

            oscenter.setProperty("/save/", false);
            oscenter.setProperty("/cancel/", false);

            this._editRecordValues(false,f);
        },

        /**
		 * Ajusta la vista para visualizar los datos de un registro
		 */
        onView: function(f) {
            this._viewOptions(f);
        },

        /**
		 * Cambia las opciones de edición disponibles en la vista de detalles de un registro
		 */
        _editOptions: function() {
            /** @type {JSONModel} OSCENTER Referencia al modelo CENTER */
            var oscenter = this.getView().getModel("OSCENTER");

            oscenter.setProperty("/modify/", false);
            oscenter.setProperty("/delete/", false);
            oscenter.setProperty("/save/", true);
            oscenter.setProperty("/cancel/", true);
            oscenter.setProperty("/code/editable/", true);
            oscenter.setProperty("/name/editable/", true);

            this._editRecordValues2(true);
        },

        /**
		 * Ajusta la vista para editar los datos de un registro
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onEdit: function(oEvent) {
            this._editOptions();
        },

        /**
		 * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
		 * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
		 */
        _recordChanged: function() {
            /**
			 * @type {JSONModel} CENTER Referencia al modelo "CENTER"
			 * @type {Boolean} flag       "true" si el registro cambió, "false" si no cambió
			 */
            var oscenter = this.getView().getModel("OSCENTER"),
                flag = false;



            if (oscenter.getProperty("/code/value") !==
				oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/code")) {
                flag = true;
            }

            if (oscenter.getProperty("/name/value") !==
				oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            //var oscenterOriginal = this.getView().getModel("oscenterOriginal");
            var original = oscenter.getProperty("/warehouses/originalRecords/"),
                actual = oscenter.getProperty("/warehouses/records/"),
                aux = [],
                center_id = oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/center_id");

            original.forEach(function(element, index){
                if(element.associated !== actual[index].associated){
                    aux.push({
                        "warehouse_id": actual[index].warehouse_id,
            	"partnership_id": actual[index].partnership_id,
            	"farm_id": actual[index].farm_id,
            	"client_id": actual[index].client_id,
                        "center_id": center_id,
                        "associated": actual[index].associated
                    });
                }
            });
            oscenter.setProperty("/changes/warehouses/", aux);

            if(aux.length > 0){
                flag = true;
            }
            if (!flag) this.onToast("No se detectaron cambios");
            return flag;
        },

        /**
		 * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
		 * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
		 */
        _recordChanged2: function() {
            /**
			 * @type {JSONModel} CENTER Referencia al modelo "CENTER"
			 * @type {Boolean} flag       "true" si el registro cambió, "false" si no cambió
			 */
            var oscenter = this.getView().getModel("OSCENTER"),
                flag = false;



            if (oscenter.getProperty("/code/value") !==
            	oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/code")) {
            	flag = true;
            }

            if (oscenter.getProperty("/name/value") !==
            	oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/name")) {
            	flag = true;
            }

            //var oscenterOriginal = this.getView().getModel("oscenterOriginal");
            var original = oscenter.getProperty("/warehouses/originalRecords/")
            if(oscenter.getProperty("/disable/value")!== original.os_disable){
                flag = true;
            }
            if (!flag) this.onToast("No se detectaron cambios");
            return flag;
        },

        onCancelEdit: function(oEvent) {
            /** @type {JSONModel} OSCENTER Referencia al modelo CENTER */
            //var oscenter = this.getView().getModel("OSCENTER");

            this.onView('cancelEdit');
        },

        /**
		 * Solicita al servicio correspondiente actualizar un registro CENTER
		 * @param  {Event} oEvent Evento que llamó esta función
		 */
        onUpdate: function(oEvent) {
            /**
			 * Si el registro que se quiere actualizar es válido y hubo algún cambio
			 * con respecto a sus datos originales
			 */
 			if ( this._validRecord2() && this._recordChanged2()) {

                var oscenter = this.getView().getModel("OSCENTER"),
                    util = this.getView().getModel("util"),
                    that = this,
                    serviceUrl = util.getProperty("/serviceUrl");
                var settings = {
                    async: true,
                    url: serviceUrl+"/center/",
                    method: "PUT",
                    data: JSON.stringify({
						 	"changes": oscenter.getProperty("/changes/"),
                        "center_id": oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/center_id"),
                        "code": oscenter.getProperty("/code/value"),
                        "name": oscenter.getProperty("/name/value"),
                        "os_disable": oscenter.getProperty("/disable/value")
                    }),
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function(res) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("oscenter", {}, true /*no history*/ );
                    },
                    error: function(err) {
                        util.setProperty("/error/status", err.status);
                        util.setProperty("/error/statusText", err.statusText);
                    }
                };
                util.setProperty("/busy/", true);
                $.ajax(settings);
            }
        },

        /**
         * Verifica si el nucleo esta en uso en otra entidad
         * @param {JSON} center_id
         */
        onVerifyIsUsed: async function(center_id){
            let ret;

            const response = await fetch("/center/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    center_id: center_id
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
            var oBundle = this.getView().getModel("i18n").getResourceBundle(),
                confirmation = oBundle.getText("confirmation"),
                that = this,
                util = this.getView().getModel("util"),
                oscenter = this.getView().getModel("OSCENTER");
            /**
			 * @type {Object} json     Objeto a enviar en la solicitud
			 * @type {Object} settings Opciones de la llamada a la función ajax
			 */
            let center_id = oscenter.getProperty(oscenter.getProperty("/selectedRecordPath/") + "/center_id");
            let cond = await this.onVerifyIsUsed(center_id);
            if(cond){
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new Text({
                        text: "No se puede eliminar el Núcleo, porque está siendo utilizado."
                    }),
                    beginButton: new Button({
                        text: "OK",
                        press: function() {
                            dialog.close();
                            that.confirmDeleteDlg.close();
                        }
                    }),
                    afterClose: function() {
                        dialog.destroy();
                    }
                });
        
                dialog.open();
            }else{
                
                util.setProperty("/busy/", true);
                var dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Desea eliminar este núcleo?"
                    }),
    
                    beginButton: new Button({
                        text: "Si",
                        press: function() {
                            var json = {
                                "center_id": center_id
                            },
                            serviceUrl = util.getProperty("/serviceUrl"),
                            settings = {
                                async: true,
                                url: serviceUrl + "/center",
                                method: "DELETE",
                                data: JSON.stringify(json),
                                dataType: "json",
                                contentType: "application/json; charset=utf-8",
                                success: function(res) {
                                    util.setProperty("/busy/", false);
                                    that.onToast(that.getI18n().getText("OS.recordDeleted"));
                                    that.getRouter().navTo("oscenter", {}, true);
                                    dialog.close();
                                },
                                error: function(err) {
                                    that.onToast("Error de comunicación");
                                }
                            };
                            //Realiza la llamada ajax
                            $.ajax(settings);
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
                nwCode = input.getValue()
            //input.setValue(input.getValue().trim());
            let oscenter = this.getView().getModel("OSCENTER");

            if(nwCode.length>45){
                oscenter.setProperty("/name/state", "Error");
                oscenter.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                oscenter.setProperty("/name/ok", false);
            }else{
                this.checkChange(input.getValue().toString(), "/name", "changeName");
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
            let oscenter = this.getView().getModel("OSCENTER");

            if(nwCode.length>20){
                oscenter.setProperty("/code/state", "Error");
                oscenter.setProperty("/code/stateText", "Excede el limite de caracteres permitido (20)");
                oscenter.setProperty("/code/ok", false);
            }else{
                this.checkChange(input.getValue().toString(), "/code", "changeCode");
            }
        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function(name,field, funct){
            let mdModel= this.getModel("OSCENTER");
            if (name=="" || name===null){
                mdModel.setProperty(field+"/state", "None");
                mdModel.setProperty(field+"/stateText", "");
                mdModel.setProperty(field+"/ok", false);
            }
            else{
                let registers = mdModel.getProperty("/records");
                let found
                if(funct === "changeCode"){
                    found = await registers.find(element => (element.code).toLowerCase() === name.toLowerCase());
                }else{
                    found = await registers.find(element => (element.name).toLowerCase() === name.toLowerCase());
                }

                if(found === undefined){
                    mdModel.setProperty(field+"/state", "Success");
                    mdModel.setProperty(field+"/stateText", "");
                    mdModel.setProperty(field+"/ok", true);
                }else{
                    mdModel.setProperty(field+"/state", "Error");
                    mdModel.setProperty(field+"/stateText", (funct==="changeCode") ? "código ya existente" : "nombre ya existente");
                    mdModel.setProperty(field+"/ok", false);
                }
            }
        }
    });
});
