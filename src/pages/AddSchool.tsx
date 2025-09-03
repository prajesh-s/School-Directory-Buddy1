import { useState } from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { z } from "zod"
import { supabase } from "@/integrations/supabase/client"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { useToast } from "@/hooks/use-toast"
import Navigation from "@/components/Navigation"

const schoolSchema = z.object({
  name: z.string()
    .min(2, "School name must be at least 2 characters")
    .max(100, "School name must not exceed 100 characters")
    .regex(/^[a-zA-Z\s\-\.&']+$/, "School name can only contain letters, spaces, hyphens, periods, and ampersands")
    .refine(val => val.trim().length > 0, "School name cannot be empty or just spaces"),
  address: z.string()
    .min(10, "Address must be at least 10 characters")
    .max(200, "Address must not exceed 200 characters")
    .refine(val => val.trim().length > 0, "Address cannot be empty or just spaces"),
  city: z.string()
    .min(2, "City must be at least 2 characters")
    .max(50, "City must not exceed 50 characters")
    .regex(/^[a-zA-Z\s\-\.]+$/, "City can only contain letters, spaces, hyphens, and periods")
    .refine(val => val.trim().length > 0, "City cannot be empty or just spaces"),
  state: z.string()
    .min(2, "State must be at least 2 characters")
    .max(50, "State must not exceed 50 characters")
    .regex(/^[a-zA-Z\s]+$/, "State can only contain letters and spaces")
    .refine(val => val.trim().length > 0, "State cannot be empty or just spaces"),
  contact: z.string()
    .min(10, "Contact number must be at least 10 digits")
    .max(15, "Contact number must not exceed 15 digits")
    .regex(/^[\+]?[1-9][\d]{9,14}$/, "Please enter a valid contact number (10-15 digits, may start with +)")
    .refine(val => val.trim().length > 0, "Contact number cannot be empty or just spaces"),
  email_id: z.string()
    .email("Please enter a valid email address")
    .min(5, "Email must be at least 5 characters")
    .max(100, "Email must not exceed 100 characters")
    .refine(val => val.trim().length > 0, "Email cannot be empty or just spaces"),
  image: z.instanceof(FileList)
    .optional()
    .refine(files => !files || files.length === 0 || files[0].size <= 5 * 1024 * 1024, "Image size must be less than 5MB")
    .refine(files => !files || files.length === 0 || ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(files[0].type), "Only JPEG, PNG, and WebP images are allowed")
})

type SchoolFormData = z.infer<typeof schoolSchema>

const AddSchool = () => {
  const [loading, setLoading] = useState(false)
  const { toast } = useToast()
  
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors }
  } = useForm<SchoolFormData>({
    resolver: zodResolver(schoolSchema)
  })

  const onSubmit = async (data: SchoolFormData) => {
    setLoading(true)
    try {
      let imageUrl = ""
      
      // Upload image if provided
      if (data.image && data.image[0]) {
        const file = data.image[0]
        const fileExt = file.name.split('.').pop()
        const fileName = `${Math.random()}.${fileExt}`
        
        const { error: uploadError } = await supabase.storage
          .from('school-images')
          .upload(fileName, file)
          
        if (uploadError) {
          throw uploadError
        }
        
        const { data: { publicUrl } } = supabase.storage
          .from('school-images')
          .getPublicUrl(fileName)
          
        imageUrl = publicUrl
      }
      
      // Insert school data
      const { error } = await supabase
        .from('schools')
        .insert([{
          name: data.name,
          address: data.address,
          city: data.city,
          state: data.state,
          contact: data.contact,
          email_id: data.email_id,
          image: imageUrl
        }])
        
      if (error) throw error
      
      toast({
        title: "Success!",
        description: "School added successfully",
      })
      
      reset()
    } catch (error) {
      console.error('Error adding school:', error)
      toast({
        title: "Error",
        description: "Failed to add school. Please try again.",
        variant: "destructive"
      })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      
      <div className="container mx-auto px-4 py-8">
        <div className="max-w-2xl mx-auto">
          <Card>
            <CardHeader>
              <CardTitle className="text-2xl text-center">Add New School</CardTitle>
              <CardDescription className="text-center">
                Fill in the details to add a new school to the directory
              </CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="name">School Name *</Label>
                    <Input
                      id="name"
                      {...register("name")}
                      placeholder="Enter school name"
                    />
                    {errors.name && (
                      <p className="text-sm text-destructive">{errors.name.message}</p>
                    )}
                  </div>
                  
                  <div className="space-y-2">
                    <Label htmlFor="email_id">Email Address *</Label>
                    <Input
                      id="email_id"
                      type="email"
                      {...register("email_id")}
                      placeholder="Enter email address"
                    />
                    {errors.email_id && (
                      <p className="text-sm text-destructive">{errors.email_id.message}</p>
                    )}
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="address">Address *</Label>
                  <Input
                    id="address"
                    {...register("address")}
                    placeholder="Enter full address"
                  />
                  {errors.address && (
                    <p className="text-sm text-destructive">{errors.address.message}</p>
                  )}
                </div>

                <div className="grid md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="city">City *</Label>
                    <Input
                      id="city"
                      {...register("city")}
                      placeholder="Enter city"
                    />
                    {errors.city && (
                      <p className="text-sm text-destructive">{errors.city.message}</p>
                    )}
                  </div>
                  
                  <div className="space-y-2">
                    <Label htmlFor="state">State *</Label>
                    <Input
                      id="state"
                      {...register("state")}
                      placeholder="Enter state"
                    />
                    {errors.state && (
                      <p className="text-sm text-destructive">{errors.state.message}</p>
                    )}
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contact">Contact Number *</Label>
                  <Input
                    id="contact"
                    {...register("contact")}
                    placeholder="Enter contact number"
                  />
                  {errors.contact && (
                    <p className="text-sm text-destructive">{errors.contact.message}</p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="image">School Image</Label>
                  <Input
                    id="image"
                    type="file"
                    accept="image/*"
                    {...register("image")}
                    className="file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-medium file:bg-primary file:text-primary-foreground hover:file:bg-primary/80"
                  />
                  {errors.image && (
                    <p className="text-sm text-destructive">{errors.image.message}</p>
                  )}
                </div>

                <Button 
                  type="submit" 
                  disabled={loading}
                  className="w-full"
                >
                  {loading ? "Adding School..." : "Add School"}
                </Button>
              </form>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}

export default AddSchool