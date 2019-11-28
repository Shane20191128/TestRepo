#**********************************************************************
#**********************************************************************
#**                                                                  **
#**        (C)Copyright 1985-2014, American Megatrends, Inc.         **
#**                                                                  **
#**                       All Rights Reserved.                       **
#**                                                                  **
#**      5555 Oakbrook Parkway, Suite 200, Norcross, GA 30093        **
#**                                                                  **
#**                       Phone: (770)-246-8600                      **
#**                                                                  **
#**********************************************************************
#**********************************************************************

Prepare : CreateGBEINFFile

CreateGBEINFFile: 	
	$(ECHO) \
	"{$(EOL)\
	gsub(/INTEL_GBE_DXS_FILE_PATH/,\"../$(GBE_DXS_FILE_PATH)\",$(DOUBLEDOLLAR)0)$(EOL)\
	gsub(/INTEL_GBE_IA32_EFI_FILE_PATH/,\"../$(GBE_IA32_EFI_FILE_PATH)\",$(DOUBLEDOLLAR)0)$(EOL)\
	gsub(/INTEL_GBE_EFI_FILE_PATH/,\"../$(GBE_EFI_FILE_PATH)\",$(DOUBLEDOLLAR)0)$(EOL)\
	print $(DOUBLEDOLLAR)0$(EOL)\
	}"$(EOL)\
> $(BUILD_DIR)/IntelGigabitLan.txt
	$(GAWK) -f $(BUILD_DIR)/IntelGigabitLan.txt $(GBE_FILE_INF_PATH) > $(BUILD_DIR)$(PATH_SLASH)IntelGigabitLan.inf
	

#**********************************************************************
#**********************************************************************
#**                                                                  **
#**        (C)Copyright 1985-2014, American Megatrends, Inc.         **
#**                                                                  **
#**                       All Rights Reserved.                       **
#**                                                                  **
#**      5555 Oakbrook Parkway, Suite 200, Norcross, GA 30093        **
#**                                                                  **
#**                       Phone: (770)-246-8600                      **
#**                                                                  **
#**********************************************************************
#**********************************************************************