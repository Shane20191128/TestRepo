#include <Library/DebugLib.h>
#include <Library/UefiRuntimeServicesTableLib.h>
#include <Library/UefiDriverEntryPoint.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/BaseLib.h>
#include <Library/UefiLib.h>
#include <Setup.h>

#include <IntelGigabitLanPolicy.h>
static EFI_GUID gSetupGuid = SETUP_GUID;

#if defined(UefiNetworkStack_SUPPORT) && (UefiNetworkStack_SUPPORT == 1)
#define NETWORK_STACK_GUID \
  { 0xD1405D16, 0x7AFC, 0x4695, 0xBB, 0x12, 0x41, 0x45, 0x9D, 0x36, 0x95, 0xA2 }

#pragma pack(1)
typedef struct{
  UINT8             Enable;
  UINT8             Ipv4Pxe;
  UINT8             Ipv6Pxe;
  UINT8             IpsecCertificate;
  UINT8             PxeBootWaitTime;
  UINT8             MediaDetectCount;
} NETWORK_STACK;
#pragma pack()
#endif

EFI_STATUS
EFIAPI
InstalGigabitLanPolicyProtocol (
  VOID		
  )
{
#if defined(UefiNetworkStack_SUPPORT) && (UefiNetworkStack_SUPPORT == 1)	
  EFI_STATUS                Status1;
  EFI_GUID                  gIntelGigabitLanPolicyProtocolGuid = INTEL_GIGABIT_LAN_POLICY_PROTOCOL_GUID;
  EFI_HANDLE                Handle;
  EFI_GUID                  gEfiNetworkStackSetupGuid = NETWORK_STACK_GUID;  
  NETWORK_STACK  	    mNetworkStackData;
  UINTN                     Size1;  

  Size1 = sizeof(NETWORK_STACK);
  Status1 = gRT->GetVariable(L"NetworkStackVar",&gEfiNetworkStackSetupGuid, NULL, &Size1, &mNetworkStackData);  
  Handle = NULL;  

  if (mNetworkStackData.Enable == 1){	
      Status1 = gBS->InstallProtocolInterface (
                    &Handle,
                    &gIntelGigabitLanPolicyProtocolGuid,
                    EFI_NATIVE_INTERFACE,
                    NULL
                    );
      return Status1;
  }
  else{
    return EFI_UNSUPPORTED;
  }	  

#else
  DEBUG ((DEBUG_INFO, "NetworkStack module doesn't add or support in this project.\n"));  
  return EFI_SUCCESS;  
#endif
}

EFI_STATUS
EFIAPI
IntelGigabitLanDxeEntryPoint (
  IN EFI_HANDLE             ImageHandle,
  IN EFI_SYSTEM_TABLE       *SystemTable
  )
{
  EFI_STATUS                Status;
#if defined(CSM_SUPPORT) && (CSM_SUPPORT == 1)
  SETUP_DATA                SetupData;
  UINTN                     Size;
  UINT8                     SecData = 0;
#endif   

  
  DEBUG ((DEBUG_INFO, "IntelGigabitLanDxeEntryPoint start..\n"));  
#if defined(CSM_SUPPORT) && (CSM_SUPPORT == 1)    
  Size = sizeof(UINT8);
  Status = gRT->GetVariable (L"SecureBoot", &gEfiGlobalVariableGuid, NULL, &Size, &SecData);

  if (!EFI_ERROR(Status) && (SecData != 0)) {
    // No CSM in secure boot mode
    Status = InstalGigabitLanPolicyProtocol();

    DEBUG ((DEBUG_INFO, "Install gIntelGigabitLanPolicy Protocol when set GigabitLanDependency to 1 in secure boot mode.. %r\n",Status));  
    if (EFI_ERROR (Status)) {
        return Status;
    }	  
  } //if in secure boot mode
  else {    
    Size = sizeof(SETUP_DATA);    
    Status = gRT->GetVariable(L"Setup", &gSetupGuid, NULL, &Size, &SetupData);    

    if (SetupData.CsmSupport == 0){		    
	Status = InstalGigabitLanPolicyProtocol();	      
        DEBUG ((DEBUG_INFO, "Install gIntelGigabitLanPolicy Protocol when CSM disable or Network set to UEFI.. %r\n",Status));
    }
    else{
	if (SetupData.PxeOpRom == 1){
	    Status = InstalGigabitLanPolicyProtocol();	      

	    DEBUG ((DEBUG_INFO, "Install gIntelGigabitLanPolicy Protocol when CSM disable or Network set to UEFI.. %r\n",Status));
	}
	if (EFI_ERROR (Status)) {
	    return Status;
	}	    	    
    }
  }
#else
  Status = InstalGigabitLanPolicyProtocol();	      

  DEBUG ((DEBUG_INFO, "If does't support CSM,install gIntelGigabitLanPolicy Protocol when set GigabitLanDependency to 1.. %r\n",Status));  
  if (EFI_ERROR (Status)) {
    return Status;
  }
#endif
  DEBUG ((DEBUG_INFO, "IntelGigabitLanDxeEntryPoint end..\n")); 
  return Status;
}  
