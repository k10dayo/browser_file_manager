const HamburgerClick ={
    mounted(){
        this.el.addEventListener("click", e => {
            console.log("jsイベント　ハンバーガーメニュー")
            manager_menu = document.querySelector("#manager_menu")
            side_menu = document.querySelector("#side_menu")
            console.log(manager_menu)
            manager_menu.classList.toggle("action_manager_menu")
            side_menu.classList.toggle("action_side_menu")
        })
    }
}

export default HamburgerClick;