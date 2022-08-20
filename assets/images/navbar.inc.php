<?php if (isset($__hide_header) && $__hide_header == 'false' || !isset($__hide_header)) : ?>
<nav class="theme-navbar" id="theme-navbar">
  <!-- notices-bar -->
  <div class="notices-bar" id="notices-bar">
    <div class="container-fluid">
      <!-- content -->
      <div class="content">
        <!-- text -->
        <p class="text">Hostlic Special Deals! Save 75% on all Shared Hosting Plans & Locations</p>
        <!-- action-btn -->
        <a href="shared-hosting.php" class="action-btn">Buy Now</a>
        <!-- close-btn -->
        <div class="close-btn" id="close-notices-bar-btn">
          <img src="assets/images/templates/navbar/close.png" class="img-fluid" alt="Down Arrow">
        </div>
      </div>
    </div>
  </div>
  <div class="container-fluid">
    <!-- nav-top -->
    <div class="nav-top d-flex align-items-center">
      <!-- menu-icon -->
      <div class="menu-icon" id="open-links-btn">
        <img src="assets/images/templates/navbar/hamburger.png" class="menu-icon img-fluid" alt="HostX">
      </div>
      <!-- brand -->
      <a href="#" class="brand d-flex align-items-center">
        <img src="assets/images/templates/navbar/logo-d.png" class="dt-img img-fluid" alt="HostX">
        <img src="assets/images/templates/navbar/logo-l.png" class="lt-img img-fluid" alt="HostX">
      </a>
      <!-- options -->
      <div class="options d-md-flex d-none align-items-center justify-content-end ml-auto">
        <!-- c-link -->
        <a href="https://www.hostlic.com/client/clientarea.php" class="c-link">
          <img src="assets/images/templates/navbar/gear.png" class="icon" alt="icon">
          <span class="text">Shared Control Panel</span>
        </a>
        <!-- c-link -->
        <a href="https://www.hostlic.com/client/clientarea.php" class="c-link">
          <img src="assets/images/templates/navbar/network.png" class="icon" alt="icon">
          <span class="text">VPS Control Panel</span>
        </a>
        <!-- buttons -->
        <div class="buttons">
          <a href="trial.html" class="btn btn-fill-primary btn-sm btn-rounded shadow-off text-uppercase mr--sm">Free Trial</a>
          <a href="login.html" class="btn btn-outline-dark btn-sm btn-rounded shadow-off text-uppercase">Login</a>
        </div>
        <!-- lang -->
        <div class="lang" id="lang">
          <!-- current -->
        
          <!-- lang-menu -->
          <div class="lang-menu" id="lang-menu">
            <a href="#" class="lang-item active">English</a>
            <a href="#" class="lang-item">Italian</a>
            <a href="#" class="lang-item">Arabic</a>
            <a href="#" class="lang-item">French</a>
            <a href="#" class="lang-item">German</a>
            <a href="#" class="lang-item">Chinese</a>
            <a href="#" class="lang-item">English</a>
            <a href="#" class="lang-item">Italian</a>
            <a href="#" class="lang-item">Arabic</a>
            <a href="#" class="lang-item">French</a>
            <a href="#" class="lang-item">German</a>
            <a href="#" class="lang-item">Chinese</a>
            <a href="#" class="lang-item">English</a>
            <a href="#" class="lang-item">Italian</a>
            <a href="#" class="lang-item">Arabic</a>
            <a href="#" class="lang-item">French</a>
            <a href="#" class="lang-item">German</a>
            <a href="#" class="lang-item">Chinese</a>
          </div>
        </div>
      </div>
      <!-- second-options -->
      <div class="second-options d-md-none d-flex align-content-center justify-content-end ml-auto">
        <!-- o-link -->
      
        <!-- o-link -->
        <div class="o-link user-link" id="user-menu-btn">
          <img src="assets/images/templates/navbar/profile.png" class="icon" alt="Icon">
          <!-- user-dropdown-menu -->
          <ul class="user-dropdown-menu list-unstyled" id="user-dropdown-menu">
            <!-- uddm-link-parent -->
            <li class="uddm-link-parent">
              <div class="title-2">Registered Users</div>
              <p class="para-2">Have an account? Sign in now.</p>
              <a href="#" class="uddm-link">Sign In</a>
            </li>
            <!-- uddm-link-parent -->
            <li class="uddm-link-parent">
              <div class="title-2">New Customer</div>
              <p class="para-2">New to Hostlic? Create an account to get started today.</p>
              <a href="#" class="uddm-link">Create an Account</a>
            </li>
          </ul>
        </div>
        <!-- o-link -->
      
      </div>
    </div>
    
    <style>
    .aw-fixed{
    position: fixed;
    top: 0;
    left: 0;
    z-index: 9999;
    width: 100%;
}
       ul.dropdown-menu {
    background: #0b0c1b !important;
    border: none !important;
    width: 100% !important;
    max-width: 100% !important;
    position: fixed !important;padding:0px 20px !important;
    left: 0;
    top: 124px
}
.aw-sub-menu{width:70%;
    justify-content: end;
    border-right: 1px dotted #fff;padding:0 20px;
}
.aw-sub-desc{width:30%;padding:0 20px;}
.aw-sub-menu>li {
    padding:15px 10px;
    margin-right: 10px;
    text-align: center;
    list-style: none;
}
.aw-sub-menu>li:hover{
    background: rgba(255,255,255,0.1);
}
.aw-sub-menu img {
    height: 60px;
    margin-bottom: 10px;
}
.aw-sub-menu p {
    color: #d6d6d6;
    font-size: 12px;
    font-weight: 600;line-height:15px;margin-bottom:0px;
    text-transform: uppercase;
}
span.clr-yellow{

    font-size: 10px;
    color: #ffe05d;

}

h3.descTitle {
    color: #f8f8f8;
    text-transform: uppercase;
    font-size: 20px;
}
p.desc {
    font-size: 12px;
    color: #f9f9f9;
    margin-top: 10px;
    margin-bottom: 0;
}

.aw-active::after{
    transform: rotate(180deg);}


@media only screen and (max-width: 1200px) {
    .aw-sub-desc,.aw-sub-menu img{display:none !important;}
    .aw-sub-menu{width:100% !important;border:none !important;padding:5px !important;
    flex-direction: column;}
    .aw-sub-menu>li>a{
    display: flex;
    justify-content: space-between;
    width: 100%;
    align-items: center;
    border-bottom: 1px solid #ddd;
    padding-bottom: 10px;
}
    .has-dropdown-menu>.dropdown-menu{
        position:relative !important;padding:5px !important;
        top:0px !important;max-width: 380px !important;border-radius:0px !important;
    }
    
    
}




    </style>
    
    
    <!-- nav-bottom -->
    <div class="nav-bottom d-flex align-items-center justify-content-between sticky-top">
      <!-- info -->
      <div class="info d-flex align-items-center">
        <!-- item -->
        <a href="tel:+1 (850) 801-5178" class="item">
          <img src="assets/images/icons/fill-font-icons/fi-sr-phone-call.svg" class="img-fluid" alt="Icon">
          <span class="text">+1 (850) 801-5178</span>
        </a>
      </div>
      <!-- links -->
      <div class="links d-xl-flex align-items-center ml-auto" id="theme-navbar-links">
        <!-- close-links-btn -->
        <div class="close-links-btn" id="close-links-btn">
          <img src="assets/images/templates/navbar/close.png" class="img-fluid" alt="Close">
        </div>
        <!-- link -->
        <div class="link active">
 
        </div>
        <!-- link -->
        <div class="link has-dropdown-menu">
          <a href="#">HOSTING</a>
          <!-- dropdown-menu -->
          <ul class="dropdown-menu">
            <!-- group-title -->
           <div class="aw-navigation d-flex align-items-center justify-content-between">
               <div class="aw-sub-menu d-flex">
                   
                   <li data-title="Server Finder" data-desc="Exceptional performance thanks to Arm64-based architecture" data-price="$32.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder</p>
                       <span class="clr-yellow">from $32.10</span>
                   </a></li>
                   
                   
                   <li data-title="Server Finder 3" data-desc="Exceptional performance thanks to Arm64-based architecture" data-price="$29.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder 3</p>
                       <span class="clr-yellow">from $29.10</span>
                   </a></li>
                   
                   <li data-title="Server Finder 4" data-desc="Exceptional performance thanks to Arm64-based architecture to Arm64-based architecture" data-price="$22.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder 4</p>
                       <span class="clr-yellow">from $22.10</span>
                   </a></li>
                   <li data-title="Server Finder 2" data-desc="Exceptional performance thanks to Arm64-based  Arm64-based architecture" data-price="$12.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder 2</p>
                       <span class="clr-yellow">from $12.10</span>
                   </a></li>
                   <li data-title="Server Finder 5" data-desc="Exceptional performance thanks to Arm64-based architecture" data-price="$32.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder 5</p>
                       <span class="clr-yellow">from $32.10</span>
                   </a></li>
                   
               </div><!-- ===== sub-menu ===== ---->
               
               
               <div class="aw-sub-desc">
                   <h3 class="descTitle">Server Finder</h3>
                   <span class="clr-yellow desc-price">from $13.10</span>
                   <p class="desc">Exceptional performance thanks to Arm64-based architecture</p>
               </div><!--- ===== sub-desc ====== --->
               
           </div>
            
          </ul>
        </div>
        <!-- link -->
        <div class="link has-dropdown-menu">
          <a href="#">RESELLER HOSTING</a>
         <!-- dropdown-menu -->
          
          <ul class="dropdown-menu">
            <!-- group-title -->
           <div class="aw-navigation d-flex align-items-center justify-content-between">
               <div class="aw-sub-menu d-flex">
                   
                   <li data-title="Server Finder" data-desc="Exceptional performance thanks to Arm64-based architecture" data-price="$32.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder</p>
                       <span class="clr-yellow">from $32.10</span>
                   </a></li>
                   
                   
                   <li data-title="Server Finder 3" data-desc="Exceptional performance thanks to Arm64-based architecture" data-price="$29.10">
                       <a href="">
                       <img src="https://www.hetzner.com/assets/Uploads/icon-circle-serverfinder.svg">
                       <p>Server Finder 3</p>
                       <span class="clr-yellow">from $29.10</span>
                   </a></li>
                   
                   
                   
               </div><!-- ===== sub-menu ===== ---->
               
               
               <div class="aw-sub-desc">
                   <h3 class="descTitle">Server Finder</h3>
                   <span class="clr-yellow desc-price">from $13.10</span>
                   <p class="desc">Exceptional performance thanks to Arm64-based architecture</p>
               </div><!--- ===== sub-desc ====== --->
               
           </div>
            
          </ul>
        </div>
        <!-- link -->
        <div class="link">
          <a href="#">VPS Hosting</a>
        </div>
        <!-- link -->
        <div class="link">
          <a href="#">Dedicated Servers</a>
        </div>
        <!-- link -->
		
        <div class="link">
          <a href="#">Domains</a>
        </div>
		<!-- link -->
        <div class="link">
          <a href="#">Support</a>
        </div>
        <!-- link -->
       
        <!-- link -->
        
        <!-- indicator -->
        <span class="indicator"></span>
      </div>
      <!-- side-box-btn -->
    
    </div>
    <!-- side-box -->
    <div class="side-box scroll-area" id="side-box">
      <!-- mega-menu -->
      
            </div>
          </div>
        </div>
      </div>
      <!-- close-side-box-btn -->
      <div class="close-side-box-btn" id="close-side-box-btn">
 
      </div>
    </div>
  </div>
</nav>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    $(document).ready(function(){
        $(window).scroll(function() {    
    var scroll = $(window).scrollTop();

    if (scroll >= 50) {
        //clearHeader, not clearheader - caps H
        $("#theme-navbar").addClass("aw-fixed");
    }
    else{
        
        $("#theme-navbar").removeClass("aw-fixed");
    }
}); //missing );
        
        
        
      var top=$('#theme-navbar').height();
      $('ul.dropdown-menu').css('top',top+'px')
      console.log(top);
      $('.aw-sub-menu>li').mouseover(function(){
        var title=$(this).data('title');
        var desc=$(this).data('desc');
        var price=$(this).data('price');
        
        $('.descTitle').html(title);
        $('.desc').html(desc);
        $('.desc-price').html('from '+price);
        
      });
      
      $('.has-dropdown-menu').click(function(){
          if ($(this).hasClass('open-dropdown-menu')){
          $('.has-dropdown-menu').removeClass('open-dropdown-menu');
          $(this).addClass('open-dropdown-menu');
          $('.has-dropdown-menu>a').removeClass('aw-active');
          $(this).find('a').addClass('aw-active');
          
          }
          else{
              $(this).removeClass('open-dropdown-menu');
          $(this).find('a').removeClass('aw-active');
          }
      });
 
    });
</script>


<?php endif; ?>
