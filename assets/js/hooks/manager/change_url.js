const ChangeUrl ={
    mounted(){
        this.el.addEventListener("click", e => {
            console.log("チェンジURL")
            console.log(this.el.getAttribute("phx-value-path"))
            history.replaceState(null, "hello", `live?path=${this.el.getAttribute("phx-value-path")}`)
        })
    }
}

export default ChangeUrl;