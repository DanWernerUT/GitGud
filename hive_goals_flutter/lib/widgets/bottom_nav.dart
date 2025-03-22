import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  bool _isCalendarMenuOpen = false;
  bool _isGoalsMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _menuAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _menuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleCalendarMenu() {
    setState(() {
      if (_isCalendarMenuOpen) {_isCalendarMenuOpen = false;}
      _isCalendarMenuOpen = !_isCalendarMenuOpen;
      if (_isCalendarMenuOpen) {_animationController.forward();} 
      else {_animationController.reverse();}
    });
  }
  
  void _toggleGoalsMenu() {
     setState(() {
      if (_isGoalsMenuOpen) {_isGoalsMenuOpen = false;}
      _isGoalsMenuOpen = !_isGoalsMenuOpen;
      if (_isGoalsMenuOpen) {_animationController.forward();} 
      else {_animationController.reverse();}
    });
  }
  
  void _closeMenus() {
    if (_isCalendarMenuOpen || _isGoalsMenuOpen) {
      setState(() {
        _isCalendarMenuOpen = false;
        _isGoalsMenuOpen = false;
        _animationController.reverse();
      });
    }
  }
  
  void _handleNavTap(int index) {
    switch(index){
      case 3: 
        if(_isCalendarMenuOpen){
          _closeMenus();
        } else {
          _closeMenus();
         _toggleCalendarMenu();
        }
        widget.onTap(3);
        break;
      case 4:
        widget.onTap(4);
        break;
      case 5:
        widget.onTap(5);
        break;
      case 6:
        if(_isGoalsMenuOpen) {
         _closeMenus();
        } else {
         _closeMenus();
         _toggleGoalsMenu();
        }
        widget.onTap(6);
        break;
      case 7:
        widget.onTap(7);
        break;
      case 8:
        widget.onTap(8);
        break;
      default: 
        _closeMenus();
        widget.onTap(index);
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    final navBarWidth = MediaQuery.of(context).size.width - 60;
    
    int effectiveActiveIndex = widget.currentIndex;    
    return SizedBox(
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          if (_isCalendarMenuOpen)
            AnimatedBuilder(
              animation: _menuAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 47,
                  right: 30,
                  child: Opacity(
                    opacity: _menuAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _menuAnimation.value) * 20),
                      child: Container(
                        width: navBarWidth,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(4, "View Calendar", context, effectiveActiveIndex),
                            _buildMenuItem(5, "Create Event", context, effectiveActiveIndex),
                            _buildMenuItem(-1, "", context, effectiveActiveIndex),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (_isGoalsMenuOpen)
            AnimatedBuilder(
              animation: _menuAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 47,
                  right: 30,
                  child: Opacity(
                    opacity: _menuAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _menuAnimation.value) * 20),
                      child: Container(
                        width: navBarWidth,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(7, "Create Goal", context, effectiveActiveIndex),
                            _buildMenuItem(8, "View Goals", context, effectiveActiveIndex),
                            _buildMenuItem(-1, "", context, effectiveActiveIndex),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
            bottom: 25,
            child: Container(
              width: navBarWidth,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItemWithIndicator(
                    0, 
                    SvgPicture.asset(
                      'lib/res/Connections.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(effectiveActiveIndex == 0 ? HiveColors.bronze : HiveColors.darkPurple, BlendMode.srcIn,),
                    ), 
                    context,
                    effectiveActiveIndex
                  ),
                  _buildNavItemWithIndicator(1, Icons.chat, context, effectiveActiveIndex),
                  SizedBox(width: 60),
                  _buildNavItemWithIndicator(3, Icons.calendar_month_outlined, context, effectiveActiveIndex),
                  _buildNavItemWithIndicator(6, Icons.check_circle_outline, context, effectiveActiveIndex),
                ],
              ),
            ),
          ),
          
          // Center Floating Button
          Positioned(
            bottom: 15,
            child: GestureDetector(
              onTap: () => _handleNavTap(2),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: effectiveActiveIndex == 2 ? HiveColors.yellow : HiveColors.chiffon,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'lib/res/HiveGoalsLight.svg',
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(int index, String title, BuildContext context, int effectiveActiveIndex) {  
    if (title.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: Text(title, style: TextStyle(color: Colors.transparent)),
      );
    }
    
    bool isActive = effectiveActiveIndex == index;
    
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Indicator positioned above the text
        Positioned(
          top: -2, // Position above the menu item
          child: Container(
            height: isActive ? 4 : 0,
            width: 30,
            decoration: BoxDecoration(
              color: HiveColors.yellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque, 
          onTap: () {
            _closeMenus();
            widget.onTap(index);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: HiveColors.darkPurple,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
      
  Widget _buildNavItemWithIndicator(int index, dynamic icon, BuildContext context, int effectiveActiveIndex) {  
    bool showIndicator = effectiveActiveIndex == index && index != 2;
    
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Indicator positioned above the icon
        Positioned(
          top: -4, // Position above the nav item
          child: Container(
            height: showIndicator ? 4 : 0,
            width: 30,
            decoration: BoxDecoration(
              color: HiveColors.yellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _handleNavTap(index),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: icon is IconData 
                ? Icon(
                    icon,
                    color: effectiveActiveIndex == index 
                      ? HiveColors.bronze 
                      : HiveColors.darkPurple,
                    size: 24,
                  )
                : icon,
            ),
          ),
        ),
      ],
    );
  }
}