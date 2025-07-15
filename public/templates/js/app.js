// Dropdown menu stop propagation
try {
    var dropdownMenus = document.querySelectorAll(".dropdown-menu.stop");
    dropdownMenus.forEach(function (e) {
        e.addEventListener("click", function (e) {
            e.stopPropagation();
        });
    });
} catch (e) {}

// Lucide icons
try { lucide.createIcons(); } catch (e) {}

// Theme color toggle
try {
    var themeColorToggle = document.getElementById("light-dark-mode");
    if (themeColorToggle) {
        themeColorToggle.addEventListener("click", function () {
            var theme = document.documentElement.getAttribute("data-bs-theme");
            document.documentElement.setAttribute("data-bs-theme", theme === "light" ? "dark" : "light");
        });
    }
} catch (e) {}

// Sidebar collapse for mobile
try {
    var collapsedToggle = document.querySelector(".mobile-menu-btn");
    const overlay = document.querySelector(".startbar-overlay");

    const changeSidebarSize = () => {
        if (window.innerWidth >= 310 && window.innerWidth <= 1440) {
            document.body.setAttribute("data-sidebar-size", "collapsed");
        } else {
            document.body.setAttribute("data-sidebar-size", "default");
        }
    };

    if (collapsedToggle) {
        collapsedToggle.addEventListener("click", function () {
            var size = document.body.getAttribute("data-sidebar-size");
            document.body.setAttribute("data-sidebar-size", size === "collapsed" ? "default" : "collapsed");
        });
    }

    if (overlay) {
        overlay.addEventListener("click", () => {
            document.body.setAttribute("data-sidebar-size", "collapsed");
        });
    }

    window.addEventListener("resize", changeSidebarSize);
    changeSidebarSize();
} catch (e) {}

// Bootstrap tooltips and popovers
try {
    const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map(function (el) {
        return new bootstrap.Tooltip(el);
    });

    var popoverTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="popover"]')
    );
    popoverTriggerList.map(function (el) {
        return new bootstrap.Popover(el);
    });
} catch (e) {}

// Sticky topbar on scroll
function windowScroll() {
    var topbar = document.getElementById("topbar-custom");
    if (topbar) {
        if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
            topbar.classList.add("nav-sticky");
        } else {
            topbar.classList.remove("nav-sticky");
        }
    }
}
window.addEventListener("scroll", function (e) {
    e.preventDefault();
    windowScroll();
});

// Vertical menu active state and scroll
const initVerticalMenu = () => {
    var collapses = document.querySelectorAll(".navbar-nav li .collapse");
    document.querySelectorAll(".navbar-nav li [data-bs-toggle='collapse']").forEach(el => {
        el.addEventListener("click", function (e) {
            e.preventDefault();
        });
    });

    collapses.forEach(el => {
        el.addEventListener("show.bs.collapse", function (t) {
            const openCollapse = t.target.closest(".collapse.show");
            document.querySelectorAll(".navbar-nav .collapse.show").forEach(e => {
                if (e !== t.target && e !== openCollapse) {
                    new bootstrap.Collapse(e).hide();
                }
            });
        });
    });

    const nav = document.querySelector(".navbar-nav");
    if (nav) {
        document.querySelectorAll(".navbar-nav a").forEach(function (t) {
            var currentUrl = window.location.href.split(/[?#]/)[0];
            if (t.href === currentUrl) {
                t.classList.add("active");
                t.parentNode.classList.add("active");
                let e = t.closest(".collapse");
                while (e) {
                    e.classList.add("show");
                    e.parentElement.children[0].classList.add("active");
                    e.parentElement.children[0].setAttribute("aria-expanded", "true");
                    e = e.parentElement.closest(".collapse");
                }
            }
        });

        setTimeout(function () {
            var t = document.querySelector(".nav-item li a.active");
            if (t) {
                var wrapper = document.querySelector(".main-nav .simplebar-content-wrapper");
                var offset = t.offsetTop - 300;
                if (wrapper && offset > 100) {
                    var duration = 600;
                    var start = wrapper.scrollTop;
                    var change = offset - start;
                    var currentTime = 0;
                    var increment = 20;

                    function animateScroll() {
                        currentTime += increment;
                        var val = easeInOutQuad(currentTime, start, change, duration);
                        wrapper.scrollTop = val;
                        if (currentTime < duration) {
                            setTimeout(animateScroll, increment);
                        }
                    }

                    function easeInOutQuad(t, b, c, d) {
                        t /= d / 2;
                        if (t < 1) return (c / 2) * t * t + b;
                        t--;
                        return (-c / 2) * (t * (t - 2) - 1) + b;
                    }

                    animateScroll();
                }
            }
        }, 200);
    }
};
initVerticalMenu();
