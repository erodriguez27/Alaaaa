sap.ui.define([
    "incubatorPlanningM/controller/BaseController",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageBox",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/Text",
    "incubatorPlanningM/controller/MasterUserAppController"
], function (BaseController, Filter, FilterOperator, MessageBox, Dialog, Button, Text,MasterUserAppController) {
    "use strict";

    return BaseController.extend("incubatorPlanningM.controller.Master", {

        onInit: function () {

            var oList = this.getView().byId("__list0");
            this._oList = oList;
            this._oListFilterState = {
                aFilter: [],
                aSearch: []
            };
            this.getRouter().getRoute("master").attachPatternMatched(this._onMasterMatched, this);

        },
        _onMasterMatched: function(oEvent) {

            var util = this.getModel("util"),
                that = this,
                ospartnership = this.getModel("ospartnership"),
                serviceUrl = util.getProperty("/serviceUrl") +util.getProperty("/" + util.getProperty("/service") + "/getPartnership");
            console.log(serviceUrl);
            var settings = {
                url: serviceUrl,
                method: "GET",
                success: function(res) {
                    console.log(res);
                    util.setProperty("/busy/", false);
                    ospartnership.setProperty("/records/", res.data);

                    var firstItem = that.getView().byId("__list0").getItems()[0];
                    var Oid = firstItem.getBindingContext("ospartnership").getPath().split("/");
                    var id = Oid[2];

                    if (firstItem) {
                        var one_item = firstItem.getBindingContext("ospartnership").getObject().partnership_id;
                        that.getRouter().navTo("detail", {
                            partnership_id: one_item,
                            id: id
                        }, false);
                    }

                },
                error: function(err) {
                    console.log(err);
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
        onSelectionChange : function(oEvent){

            var Oid = oEvent.getSource().getBindingContext("ospartnership").getPath().split("/");
            var id = Oid[2];
            console.log(id);
            console.log(oEvent.getSource().getBindingContext("ospartnership").getObject().partnership_id);
            this.getRouter().navTo("detail", {
                partnership_id: oEvent.getSource().getBindingContext("ospartnership").getObject().partnership_id,
                id: id
            }, false /*create history*/ );
        },

        onSearch: function(oEvent) {

            if (oEvent.getParameters().refreshButtonPressed) {
                this.onRefresh();
                return;
            }
            var sQuery = oEvent.getSource().getValue();
            //var sQuery = oEvent.getParameter("query");
            if (sQuery) {
                this._oListFilterState.aSearch = [new Filter("name", FilterOperator.Contains, sQuery)];
            } else {
                this._oListFilterState.aSearch = [];
            }
            this._applyFilterSearch();

        },
        _applyFilterSearch: function() {
            var aFilters = this._oListFilterState.aSearch.concat(this._oListFilterState.aFilter),
                oViewModel = this.getModel("ospartnership");

            this._oList.getBinding("items").filter(aFilters, "Application");
            // changes the noDataText of the list in case there are no filter results
            if (aFilters.length !== 0) {
                oViewModel.setProperty("/noDataText", this.getResourceBundle().getText("master.ListNoDataText"));
            } else if (this._oListFilterState.aSearch.length > 0) {
                // only reset the no data text to default when no new search was triggered
                oViewModel.setProperty("/noDataText", this.getResourceBundle().getText("master.ListNoDataText"));
            }
        },
        _updateListItemCount: function (iTotalItems) {
            var sTitle;
            // only update the counter if the length is final
            if (this._oList.getBinding("items").isLengthFinal()) {
                sTitle = this.getResourceBundle().getText("master.TitleCount", [iTotalItems]);
                this.getModel("ospartnership").setProperty("/title", sTitle);
            }
        },
        onUpdateFinished: function (oEvent) {
            this._updateListItemCount(oEvent.getParameter("total"));
        },
        goToLaunchpad: function () {
            // var dummy = this.getView().getModel("util");
            // window.location.href = dummy.getProperty("/serviceUrl") + "/Apps/launchpad/webapp";
            window.location.href = "/Apps/launchpad/webapp";
        }

    });

});
