const ItemInfoClick ={
    mounted(){
        this.el.addEventListener("click", e => {
            console.log(this.el.parentElement.querySelector("img").getAttribute("src"))
            console.log(this.el.querySelector(".item_name").innerText)

            side_menu_name = document.querySelector("#side_menu_name")
            side_menu_name.innerText = this.el.querySelector(".item_name").innerText

            side_menu_image = document.querySelector("#side_menu_image")

            side_menu_image.setAttribute("src", this.el.parentElement.querySelector("img").getAttribute("src"))
        })
    }
}

export default ItemInfoClick;