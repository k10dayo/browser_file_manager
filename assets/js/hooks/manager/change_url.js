const ChangeUrl ={
    mounted(){
        this.el.addEventListener("click", e => {
            history.replaceState(null, "hello", `live?path=${this.el.getAttribute("phx-value-path")}`)
        })
    }
}

export default ChangeUrl;