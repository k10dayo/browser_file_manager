import $ from "./jquery-3.7.0.min";
//import "./multiple_select.min.js";
//import 'multiple-select/dist/multiple-select.js';
//import "./multiple-select.min.css"

const MultipleSelect ={
    mounted(){
        // this.el.addEventListener("click", e => {
        //     history.replaceState(null, "hello", `live?path=${this.el.getAttribute("phx-value-path")}`)
        // })
        $(function () {
            $('#test').on("click", function(){
                console.log("まっとりあｍすすすすすす")
            });
            $('select').multipleSelect({
                width: 500,
                isOpen: true,
                keepOpen: true,
                multiple: true,
                filter: true,
                filterGroup: true,
                hideOptgroupCheckboxes: true,
                multipleWidth: "auto",
                formatSelectAll: function() {
                    return 'すべて';
                },
                formatAllSelected: function() {
                    return '全て選択されています';
                },
                styler: function(row) {
                    return 'max-width: 150px'
                }
            });
        });
    }
}

export default MultipleSelect;